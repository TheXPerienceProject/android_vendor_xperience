/*
#
# Copyright (C) 2018-2021 The XPerience Project
# Copyright (C) Qualcomm 
#
*/

package com.qualcomm.qti;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Binder;
import android.os.IBinder;
import android.os.Process;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.Trace;
import android.util.Log;
import com.qualcomm.qti.IPerfManager;
import java.io.File;

public class Performance {
    private static final boolean DEBUG = false;
    public static final int GAME = 2;
    private static final String PERF_SERVICE_BINDER_NAME = "vendor.perfservice";
    public static final int REQUEST_FAILED = -1;
    public static final int REQUEST_SUCCEEDED = 0;
    private static boolean RestrictUnTrustedAppAccess = false;
    private static final int SizeforHeavyGame = 524288000;
    private static final String TAG = "XPerience-Perf";
    public static final int VENDOR_FEEDBACK_WORKLOAD_TYPE = 5633;
    private static IBinder clientBinder = null;
    private static boolean hg_plug = false;
    private static boolean propflag = false;
    private static Boolean sIsChecked = false;
    private static boolean sIsPlatformOrPrivApp = true;
    private static boolean sIsUntrustedDomain = false;
    private static boolean sLoaded = false;
    private static IPerfManager sPerfService = null;
    private static IBinder sPerfServiceBinder = null;
    private static PerfServiceDeathRecipient sPerfServiceDeathRecipient = null;
    private static final boolean sPerfServiceDisabled = false;
    public HeavyGameThread HGDThread = null;
    private int UXE_EVENT_BINDAPP = 2;
    private int mHandle = 0;
    private final Object mLock = new Object();

    private native int native_perf_get_feedback(int i, String str);

    private native String native_perf_get_prop(String str, String str2);

    private native int native_perf_hint(int i, String str, int i2, int i3);

    private native int native_perf_io_prefetch_start(int i, String str, String str2);

    private native int native_perf_io_prefetch_stop();

    private native int native_perf_lock_acq(int i, int i2, int[] iArr);

    private native int native_perf_lock_acq_rel(int i, int i2, int i3, int i4, int[] iArr);

    private native int native_perf_lock_rel(int i);

    private native int native_perf_uxEngine_events(int i, int i2, String str, int i3);

    private native String native_perf_uxEngine_trigger(int i);

    public Performance() {
    }

    public Performance(Context context) {
        synchronized (Performance.class) {
            if (!sLoaded) {
                connectPerfServiceLocked();
                if (sPerfService == null) {
                    Log.e(TAG, "Perf service is unavailable.");
                } else {
                    sLoaded = true;
                }
            }
        }
        checkAppPlatformSigned(context);
    }

    public Performance(boolean isUntrusterdDomain) {
        sIsUntrustedDomain = isUntrusterdDomain;
    }

    private void connectPerfServiceLocked() {
        if (sPerfService == null) {
            Log.i(TAG, "Connecting to perf service.");
            IBinder service = ServiceManager.getService(PERF_SERVICE_BINDER_NAME);
            sPerfServiceBinder = service;
            if (service == null) {
                Log.e(TAG, "Perf service is now down, set sPerfService as null.");
                return;
            }
            try {
                PerfServiceDeathRecipient perfServiceDeathRecipient = new PerfServiceDeathRecipient();
                sPerfServiceDeathRecipient = perfServiceDeathRecipient;
                sPerfServiceBinder.linkToDeath(perfServiceDeathRecipient, 0);
                IBinder iBinder = sPerfServiceBinder;
                if (iBinder != null) {
                    sPerfService = IPerfManager.Stub.asInterface(iBinder);
                }
                if (sPerfService != null) {
                    try {
                        Binder binder = new Binder();
                        clientBinder = binder;
                        sPerfService.setClientBinder(binder);
                    } catch (RemoteException e) {
                        e.printStackTrace();
                    }
                }
            } catch (RemoteException e2) {
                Log.e(TAG, "Perf service is now down, leave sPerfService as null.");
            }
        }
    }

    public int perfLockAcquire(int duration, int... list) {
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null || RestrictUnTrustedAppAccess) {
                        return -1;
                    }
                    this.mHandle = sPerfService.perfLockAcquire(duration, list);
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfLockAcquire", e);
                    return -1;
                }
            }
        } else {
            this.mHandle = native_perf_lock_acq(this.mHandle, duration, list);
        }
        int i = this.mHandle;
        if (i <= 0) {
            return -1;
        }
        return i;
    }

    public int perfLockRelease() {
        int retValue;
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null || RestrictUnTrustedAppAccess) {
                        retValue = -1;
                    } else {
                        retValue = sPerfService.perfLockReleaseHandler(this.mHandle);
                    }
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfLockRelease", e);
                    return -1;
                } catch (Throwable th) {
                    throw th;
                }
            }
            return retValue;
        }
        int retValue2 = native_perf_lock_rel(this.mHandle);
        this.mHandle = 0;
        return retValue2;
    }

    public int perfLockReleaseHandler(int _handle) {
        int retValue;
        if (sIsPlatformOrPrivApp && !sIsUntrustedDomain) {
            return native_perf_lock_rel(_handle);
        }
        synchronized (this.mLock) {
            try {
                if (sPerfService == null || RestrictUnTrustedAppAccess) {
                    retValue = -1;
                } else {
                    retValue = sPerfService.perfLockReleaseHandler(_handle);
                }
            } catch (RemoteException e) {
                Log.e(TAG, "Error calling perfLockRelease(handle)", e);
                return -1;
            } catch (Throwable th) {
                throw th;
            }
        }
        return retValue;
    }

    public int perfHint(int hint, String userDataStr, int userData1, int userData2) {
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null || RestrictUnTrustedAppAccess) {
                        return -1;
                    }
                    this.mHandle = sPerfService.perfHint(hint, userDataStr, userData1, userData2, Process.myTid());
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfHint", e);
                    return -1;
                }
            }
        } else {
            this.mHandle = native_perf_hint(hint, userDataStr, userData1, userData2);
        }
        int i = this.mHandle;
        if (i <= 0) {
            return -1;
        }
        return i;
    }

    public int perfGetFeedback(int req, String userDataStr) {
        int mInfo;
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null) {
                        return -1;
                    }
                    mInfo = sPerfService.perfHint(req, userDataStr, 0, 0, Process.myTid());
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfHint", e);
                    return -1;
                } catch (Throwable th) {
                    throw th;
                }
            }
        } else {
            mInfo = native_perf_get_feedback(req, userDataStr);
        }
        if (mInfo <= 0) {
            return -1;
        }
        return mInfo;
    }

    public int perfIOPrefetchStart(int PId, String Pkg_name, String Code_path) {
        return native_perf_io_prefetch_start(PId, Pkg_name, Code_path);
    }

    public int perfIOPrefetchStop() {
        return native_perf_io_prefetch_stop();
    }

    public int perfUXEngine_events(int opcode, int pid, String pkg_name, int lat, String CodePath) {
        if (!propflag) {
            hg_plug = Boolean.parseBoolean(perfGetProp("ro.vendor.perf.wlc.heavygame", "false"));
            propflag = true;
        }
        if (opcode == this.UXE_EVENT_BINDAPP) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null) {
                        return -1;
                    }
                    this.mHandle = sPerfService.perfUXEngine_events(opcode, pid, pkg_name, lat);
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfHint", e);
                    return -1;
                }
            }
        } else {
            this.mHandle = native_perf_uxEngine_events(opcode, pid, pkg_name, lat);
        }
        int i = this.mHandle;
        if (i <= 0) {
            return -1;
        }
        return i;
    }

    public int perfLockAcqAndRelease(int handle, int duration, int numArgs, int reserveNumArgs, int... list) {
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null || RestrictUnTrustedAppAccess) {
                        return -1;
                    }
                    this.mHandle = sPerfService.perfLockAcqAndRelease(handle, duration, numArgs, reserveNumArgs, list);
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfLockAcqAndRelease", e);
                    return -1;
                }
            }
        } else {
            this.mHandle = native_perf_lock_acq_rel(handle, duration, numArgs, reserveNumArgs, list);
        }
        int i = this.mHandle;
        if (i <= 0) {
            return -1;
        }
        return i;
    }

    public String perfUXEngine_trigger(int opcode) {
        return native_perf_uxEngine_trigger(opcode);
    }

    private void checkAppPlatformSigned(Context context) {
        synchronized (sIsChecked) {
            if (context != null) {
                if (!sIsChecked.booleanValue()) {
                    try {
                        PackageInfo pkg = context.getPackageManager().getPackageInfo(context.getPackageName(), 64);
                        PackageInfo sys = context.getPackageManager().getPackageInfo("android", 64);
                        boolean z = false;
                        if ((pkg != null && pkg.signatures != null && pkg.signatures.length > 0 && sys.signatures[0].equals(pkg.signatures[0])) || pkg.applicationInfo.isPrivilegedApp()) {
                            z = true;
                        }
                        sIsPlatformOrPrivApp = z;
                        if (!(pkg == null || pkg.applicationInfo == null || pkg.applicationInfo.targetSdkVersion >= 28)) {
                            RestrictUnTrustedAppAccess = true;
                        }
                    } catch (PackageManager.NameNotFoundException e) {
                        Log.e(TAG, "packageName is not found.");
                        sIsPlatformOrPrivApp = true;
                    }
                    sIsChecked = true;
                }
            }
        }
    }

    private final class PerfServiceDeathRecipient implements IBinder.DeathRecipient {
        private PerfServiceDeathRecipient() {
        }

        public void binderDied() {
            synchronized (Performance.this.mLock) {
                Log.e(Performance.TAG, "XPerience-Perf Service died.");
                if (Performance.sPerfServiceBinder != null) {
                    Performance.sPerfServiceBinder.unlinkToDeath(this, 0);
                }
                Performance.sPerfServiceBinder = null;
                Performance.sPerfService = null;
            }
        }
    }

    public String perfGetProp(String prop_name, String def_val) {
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            return def_val;
        }
        return native_perf_get_prop(prop_name, def_val);
    }

    private int perfHeavyGameClassify(int PId, String PkgName, String CodePath) {
        HeavyGameThread heavyGameThread = new HeavyGameThread(PId, PkgName, CodePath);
        this.HGDThread = heavyGameThread;
        if (heavyGameThread == null) {
            return 0;
        }
        new Thread(this.HGDThread).start();
        return 0;
    }

    private class HeavyGameThread implements Runnable {
        public String CodePath;
        public int PId;
        public String PkgName;

        public HeavyGameThread(int PId2, String PkgName2, String CodePath2) {
            this.CodePath = CodePath2;
            this.PkgName = PkgName2;
            this.PId = PId2;
        }

        private long getFolderSize(File folder) {
            long size = 0;
            try {
                File[] files = folder.listFiles();
                if (files == null) {
                    return 0;
                }
                int count = files.length;
                int i = 0;
                while (true) {
                    if (i >= count) {
                        break;
                    }
                    File f = files[i];
                    if (f.isFile()) {
                        size += f.length();
                        if (size >= SizeforHeavyGame) {
                            break;
                        }
                    } else if (f.isDirectory()) {
                        size += getFolderSize(f);
                        if (size >= SizeforHeavyGame) {
                            break;
                        }
                    } else {
                        continue;
                    }
                    i++;
                }
                return size;
            } catch (SecurityException e) {
                Log.e(Performance.TAG, "getFolderSize () : " + e);
            }
			Log.e(Performance.TAG, "getFolderSize () 2nd : " + size);
			return size;
        }

        public void run() {
            String[] DirList;
            Trace.traceBegin(64, "HeavyGameThread");
            long totalSize = 0;
            for (String str : new String[]{"/data/data/" + this.PkgName, "/sdcard/Android/data/" + this.PkgName, "/sdcard/Android/obb/" + this.PkgName, this.CodePath}) {
                try {
                    File folder = new File(str);
                    if (folder.exists()) {
                        if (folder.isDirectory()) {
                            totalSize += Long.valueOf(getFolderSize(folder)).longValue();
                            if (totalSize >= SizeforHeavyGame) {
                                break;
                            }
                        }
                    }
                } catch (SecurityException e) {
                    Log.e(Performance.TAG, "HeavyGameThread () : " + e);
                }
            }
            synchronized (Performance.this.mLock) {
                try {
                    if (Performance.sPerfService != null) {
                        Performance.this.mHandle = Performance.sPerfService.perfHint(4165, this.PkgName, totalSize > SizeforHeavyGame ? 1 : 0, 0, Process.myTid());
                        Trace.traceEnd(64);
                    }
                } catch (RemoteException e2) {
                    Log.e(Performance.TAG, "Error calling perfHint", e2);
                }
            }
        }
    }
}
