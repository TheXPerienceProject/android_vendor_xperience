/*
#
# Copyright (C) 2018-2019 The XPerience Project
# Copyright (C) Qualcomm
#
*/
package com.qualcomm.qti;

import android.app.AppGlobals;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.IPackageManager;
import android.os.SystemProperties;
import android.os.Trace;
import android.util.Log;
import android.util.Slog;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.lang.reflect.Method;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;

public class UxPerformance {
    private static boolean EnableDebug = false;
    private static boolean EnablePAppsSpeed = false;
    private static boolean EnablePrefetch = false;
    public static final int REQUEST_FAILED = -1;
    public static final int REQUEST_SUCCEEDED = 0;
    private static final String TAG_TASKS = "UxPerf";
    private static final int UXE_SPEED_ADD = 11;
    private static final int UXE_SPEED_DEL = 12;
    private static final int UXE_SPEED_TRIGGER = 13;
    private static boolean dozeSetup = false;
    private static boolean isUxPerfContextInitialized = false;
    private static boolean isUxPerfInitialized = false;
    private static Object mUxPerf;

    private static IPackageManager f0pm;
    private static Method sUxeEventFunc;
    private static Method sUxeTrigFunc;
    private DexPrefetchThread PreDexThread = null;
    private DozeReceiver mDozeReceiver;
    private PAppsSpeedThread pAppsThread;

    public UxPerformance() {
        if (!isUxPerfInitialized && !isUxPerfContextInitialized) {
            QLogD("UX Perf module initialized");
            try {
                Class sPerfClass = Class.forName("com.qualcomm.qti.Performance");
                Method sPerfGetPropFunc = sPerfClass.getMethod("perfGetProp", String.class, String.class);
                Object mPerf = sPerfClass.newInstance();
                EnablePrefetch = Boolean.parseBoolean(sPerfGetPropFunc.invoke(mPerf, "vendor.perf.iop_v3.enable", "false").toString());
                EnableDebug = Boolean.parseBoolean(sPerfGetPropFunc.invoke(mPerf, "vendor.perf.iop_v3.enable.debug", "false").toString());
                isUxPerfInitialized = true;
            } catch (Exception e) {
                Log.e(TAG_TASKS, "Couldn't load Performance Class");
            }
        }
    }

    public UxPerformance(Context context) {
        if (!isUxPerfContextInitialized) {
            QLogD("UX Perf module initialized w/ context");
            try {
                Class sPerfClass = Class.forName("com.qualcomm.qti.Performance");
                Method sPerfGetPropFunc = sPerfClass.getMethod("perfGetProp", String.class, String.class);
                sUxeTrigFunc = sPerfClass.getMethod("perfUXEngine_trigger", Integer.TYPE);
                sUxeEventFunc = sPerfClass.getMethod("perfUXEngine_events", Integer.TYPE, Integer.TYPE, String.class, Integer.TYPE, String.class);
                Object newInstance = sPerfClass.newInstance();
                mUxPerf = newInstance;
                if (!isUxPerfInitialized) {
                    EnablePrefetch = Boolean.parseBoolean(sPerfGetPropFunc.invoke(newInstance, "vendor.perf.iop_v3.enable", "false").toString());
                    EnableDebug = Boolean.parseBoolean(sPerfGetPropFunc.invoke(mUxPerf, "vendor.perf.iop_v3.enable.debug", "false").toString());
                }
                boolean parseBoolean = Boolean.parseBoolean(sPerfGetPropFunc.invoke(mUxPerf, "vendor.iop.enable_speed", "false").toString());
                EnablePAppsSpeed = parseBoolean;
                if (!dozeSetup && parseBoolean) {
                    IntentFilter pfilter = new IntentFilter();
                    pfilter.addAction("android.os.action.DEVICE_IDLE_MODE_CHANGED");
                    pfilter.addAction("android.intent.action.SCREEN_ON");
                    pfilter.addAction("android.intent.action.SCREEN_OFF");
                    DozeReceiver dozeReceiver = new DozeReceiver();
                    this.mDozeReceiver = dozeReceiver;
                    context.registerReceiver(dozeReceiver, pfilter);
                    dozeSetup = true;
                }
                f0pm = AppGlobals.getPackageManager();
                isUxPerfContextInitialized = true;
            } catch (Exception e) {
                Log.e(TAG_TASKS, "Couldn't load Performance Class w/ context");
            }
        }
    }

    private void QLogI(String msg) {
        if (EnableDebug) {
            Slog.i(TAG_TASKS, msg);
        }
    }

    /* access modifiers changed from: private */
    public void QLogD(String msg) {
        if (EnableDebug) {
            Slog.d(TAG_TASKS, msg);
        }
    }

    private void QLogV(String msg) {
        if (EnableDebug) {
            Slog.v(TAG_TASKS, msg);
        }
    }

    /* access modifiers changed from: private */
    public void QLogE(String msg) {
        if (EnableDebug) {
            Slog.e(TAG_TASKS, msg);
        }
    }

    public int perfIOPrefetchStart(int PId, String PkgName, String CodePath) {
        if (EnablePrefetch) {
            QLogI("DexPrefetchThread Feature is Enable ");
            DexPrefetchThread dexPrefetchThread = new DexPrefetchThread(CodePath);
            this.PreDexThread = dexPrefetchThread;
            if (dexPrefetchThread == null) {
                return 0;
            }
            new Thread(this.PreDexThread).start();
            return 0;
        }
        QLogI("DexPrefetchThread Feature is disabled ");
        return -1;
    }

    private class DexPrefetchThread implements Runnable {
        public String CodePath;

        public DexPrefetchThread(String CodePath2) {
            this.CodePath = CodePath2;
        }

        public void LoadFiles(String path, String FileName) {
            String[] Files = {".art", ".odex", ".vdex"};
            UxPerformance uxPerformance = UxPerformance.this;
            uxPerformance.QLogD(" LoadFiles() path is " + path);
            for (int i = 0; i < Files.length; i++) {
                File MyFile = new File(path + FileName + Files[i]);
                if (MyFile.exists()) {
                    try {
                        FileChannel fileChannel = new RandomAccessFile(MyFile, "r").getChannel();
                        MappedByteBuffer buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, 0, fileChannel.size());
                        if (UxPerformance.EnableDebug) {
                            UxPerformance uxPerformance2 = UxPerformance.this;
                            uxPerformance2.QLogD("Before Is Buffer Loaded " + buffer.isLoaded());
                        }
                        UxPerformance uxPerformance3 = UxPerformance.this;
                        uxPerformance3.QLogD("File is " + path + FileName + Files[i]);
                        buffer.load();
                        if (UxPerformance.EnableDebug) {
                            UxPerformance uxPerformance4 = UxPerformance.this;
                            uxPerformance4.QLogD("After Is Buffer Loaded " + buffer.isLoaded());
                        }
                    } catch (FileNotFoundException e) {
                        UxPerformance uxPerformance5 = UxPerformance.this;
                        uxPerformance5.QLogE("DexPrefetchThread Can not find file " + FileName + Files[i] + "at " + path);
                    } catch (IOException e2) {
                        UxPerformance uxPerformance6 = UxPerformance.this;
                        uxPerformance6.QLogE("DexPrefetchThread IO Error file " + FileName + Files[i] + "at " + path);
                    }
                }
            }
        }

        public void run() {
            Trace.traceBegin(64, "DexPrefetchThread");
            if (this.CodePath.startsWith("/data")) {
                UxPerformance.this.QLogD("Data pkg ");
                if (new File(this.CodePath + "/oat/arm64/").exists()) {
                    LoadFiles(this.CodePath + "/oat/arm64/", "base");
                } else {
                    if (new File(this.CodePath + "/oat/arm/").exists()) {
                        LoadFiles(this.CodePath + "/oat/arm/", "base");
                    }
                }
            } else {
                UxPerformance.this.QLogD("system/vendor pkg ");
                String[] SplitPath = this.CodePath.split("/");
                String PkgName = SplitPath[SplitPath.length - 1];
                UxPerformance uxPerformance = UxPerformance.this;
                uxPerformance.QLogD("PKgNAme : " + PkgName);
                if (new File(this.CodePath + "/oat/arm64/").exists()) {
                    LoadFiles(this.CodePath + "/oat/arm64/", PkgName);
                } else {
                    if (new File(this.CodePath + "/oat/arm/").exists()) {
                        LoadFiles(this.CodePath + "/oat/arm/", PkgName);
                    }
                }
            }
            Trace.traceEnd(64);
        }
    }

    private class DozeReceiver extends BroadcastReceiver {
        private boolean pAppsThreadCreated;
        private boolean screenOff;

        private DozeReceiver() {
            this.screenOff = false;
            this.pAppsThreadCreated = false;
        }

        /* JADX WARNING: Removed duplicated region for block: B:17:0x003c  */
        /* JADX WARNING: Removed duplicated region for block: B:24:0x005a A[SYNTHETIC, Splitter:B:24:0x005a] */
        public void onReceive(Context context, Intent intent) {
            char c;
            String action = intent.getAction();
            int hashCode = action.hashCode();
            if (hashCode != -2128145023) {
                if (hashCode != -1454123155) {
                    if (hashCode == 870701415 && action.equals("android.os.action.DEVICE_IDLE_MODE_CHANGED")) {
                        c = 0;
                        if (c != 0) {
                            try {
                                UxPerformance.this.QLogD("Calling PMS broadcast receiver. Entered device idle mode");
                                if (this.screenOff && !this.pAppsThreadCreated) {
                                    UxPerformance.this.pAppsThread = new PAppsSpeedThread();
                                    if (UxPerformance.this.pAppsThread != null) {
                                        new Thread(UxPerformance.this.pAppsThread).start();
                                    }
                                    this.pAppsThreadCreated = true;
                                    return;
                                }
                                return;
                            } catch (Exception e) {
                                Log.d(UxPerformance.TAG_TASKS, "Caught exception: " + e);
                                return;
                            }
                        } else if (c == 1) {
                            this.screenOff = true;
                            return;
                        } else if (c == 2) {
                            this.screenOff = false;
                            if (UxPerformance.this.pAppsThread != null) {
                                UxPerformance.this.pAppsThread.setStopThread();
                            }
                            this.pAppsThreadCreated = false;
                            return;
                        } else {
                            return;
                        }
                    }
                } else if (action.equals("android.intent.action.SCREEN_ON")) {
                    c = 2;
                    if (c != 0) {
                    }
                }
            } else if (action.equals("android.intent.action.SCREEN_OFF")) {
                c = 1;
                if (c != 0) {
                }
            }
            c = '\uffff';
            if (c != 0) {
            }
        }
    }

    private class PAppsSpeedThread implements Runnable {
        private boolean stopPAppsThread;

        private PAppsSpeedThread() {
            this.stopPAppsThread = false;
        }

        public void setStopThread() {
            this.stopPAppsThread = true;
        }

        public void run() {
            int i;
            String str;
            try {
                boolean checkProfiles = SystemProperties.getBoolean("dalvik.vm.usejitprofiles", false);
                String defaultFilter = SystemProperties.get("pm.dexopt.bg-dexopt");
                boolean s_low = UxPerformance.f0pm.isStorageLow();
                if (!defaultFilter.equals("speed")) {
                    String ret = UxPerformance.sUxeTrigFunc.invoke(UxPerformance.mUxPerf, Integer.valueOf((int) UxPerformance.UXE_SPEED_TRIGGER)).toString();
                    if (ret == null) {
                        return;
                    }
                    if (!ret.equals("")) {
                        UxPerformance.this.QLogD("Obtained PApps: " + ret);
                        String[] pApps_del = ret.split("=");
                        int i2 = 1;
                        while (true) {
                            if (i2 >= pApps_del.length) {
                                i = 5;
                                str = " to speed mode. Result: ";
                                break;
                            } else if (this.stopPAppsThread) {
                                i = 5;
                                str = " to speed mode. Result: ";
                                break;
                            } else {
                                boolean tmp = UxPerformance.f0pm.performDexOptMode(pApps_del[i2], checkProfiles, "speed-profile", true, true, (String) null);
                                UxPerformance.this.QLogD("Removed pApp: " + pApps_del[i2] + " to speed mode. Result: " + tmp);
                                UxPerformance.sUxeEventFunc.invoke(UxPerformance.mUxPerf, Integer.valueOf((int) UxPerformance.UXE_SPEED_DEL), -1, pApps_del[i2], -1, null);
                                i2++;
                            }
                        }
                        String[] pApps_add = pApps_del[0].split("/");
                        for (int i3 = 0; i3 < pApps_add.length && !s_low && !this.stopPAppsThread; i3++) {
                            boolean tmp2 = UxPerformance.f0pm.performDexOptMode(pApps_add[i3], checkProfiles, "speed", true, true, (String) null);
                            UxPerformance.this.QLogD("Added pApp: " + pApps_add[i3] + str + tmp2);
                            if (tmp2) {
                                Method method = UxPerformance.sUxeEventFunc;
                                Object obj = UxPerformance.mUxPerf;
                                Object[] objArr = new Object[i];
                                objArr[0] = Integer.valueOf((int) UxPerformance.UXE_SPEED_ADD);
                                objArr[1] = -1;
                                objArr[2] = pApps_add[i3];
                                objArr[3] = -1;
                                objArr[4] = null;
                                method.invoke(obj, objArr);
                            } else {
                                Method method2 = UxPerformance.sUxeEventFunc;
                                Object obj2 = UxPerformance.mUxPerf;
                                Object[] objArr2 = new Object[i];
                                objArr2[0] = Integer.valueOf((int) UxPerformance.UXE_SPEED_DEL);
                                objArr2[1] = -1;
                                objArr2[2] = pApps_add[i3];
                                objArr2[3] = -1;
                                objArr2[4] = null;
                                method2.invoke(obj2, objArr2);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                Log.e(UxPerformance.TAG_TASKS, "Exception caught. " + e);
            }
        }
    }
}