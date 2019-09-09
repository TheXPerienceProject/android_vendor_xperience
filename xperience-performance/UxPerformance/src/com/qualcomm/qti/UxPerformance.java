/*
#
# Copyright (C) 2018-2019 The XPerience Project
# Copyright (C) Qualcomm
#
*/
package com.qualcomm.qti;

import android.os.SystemProperties;
import android.os.Trace;
import android.util.Slog;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;

public class UxPerformance {
    public static final int REQUEST_FAILED = -1;
    public static final int REQUEST_SUCCEEDED = 0;
    private static final String TAG_TASKS = "UxPerf";
    public boolean EnableDebug = false;
    public boolean EnablePrefetch = false;
    public DexPrefetchThread PreDexThread = null;

    private class DexPrefetchThread implements Runnable {
        public String CodePath;

        public DexPrefetchThread(String CodePath2) {
            this.CodePath = CodePath2;
        }

        public void LoadFiles(String path) {
            String[] Files = {"base.art", "base.odex", "base.vdex"};
            UxPerformance uxPerformance = UxPerformance.this;
            StringBuilder sb = new StringBuilder();
            sb.append(" LoadFiles() path is ");
            sb.append(path);
            uxPerformance.QLogD(sb.toString());
            for (int i = 0; i < Files.length; i++) {
                StringBuilder sb2 = new StringBuilder();
                sb2.append(path);
                sb2.append(Files[i]);
                if (new File(sb2.toString()).exists()) {
                    try {
                        StringBuilder sb3 = new StringBuilder();
                        sb3.append(path);
                        sb3.append(Files[i]);
                        FileChannel fileChannel = new RandomAccessFile(new File(sb3.toString()), "r").getChannel();
                        MappedByteBuffer buffer = fileChannel.map(MapMode.READ_ONLY, 0, fileChannel.size());
                        UxPerformance uxPerformance2 = UxPerformance.this;
                        StringBuilder sb4 = new StringBuilder();
                        sb4.append("Before Is Buffer Loaded ");
                        sb4.append(buffer.isLoaded());
                        uxPerformance2.QLogD(sb4.toString());
                        UxPerformance uxPerformance3 = UxPerformance.this;
                        StringBuilder sb5 = new StringBuilder();
                        sb5.append("File is ");
                        sb5.append(path);
                        sb5.append(Files[i]);
                        uxPerformance3.QLogD(sb5.toString());
                        buffer.load();
                        UxPerformance uxPerformance4 = UxPerformance.this;
                        StringBuilder sb6 = new StringBuilder();
                        sb6.append("After Is Buffer Loaded ");
                        sb6.append(buffer.isLoaded());
                        uxPerformance4.QLogD(sb6.toString());
                    } catch (FileNotFoundException e) {
                        UxPerformance uxPerformance5 = UxPerformance.this;
                        StringBuilder sb7 = new StringBuilder();
                        sb7.append("DexPrefetchThread Can not find file ");
                        sb7.append(Files[i]);
                        sb7.append("at ");
                        sb7.append(path);
                        uxPerformance5.QLogE(sb7.toString());
                    } catch (IOException e2) {
                        UxPerformance uxPerformance6 = UxPerformance.this;
                        StringBuilder sb8 = new StringBuilder();
                        sb8.append("DexPrefetchThread IO Error file ");
                        sb8.append(Files[i]);
                        sb8.append("at ");
                        sb8.append(path);
                        uxPerformance6.QLogE(sb8.toString());
                    }
                }
            }
        }

        public void run() {
            Trace.traceBegin(64, "DexPrefetchThread");
            StringBuilder sb = new StringBuilder();
            sb.append(this.CodePath);
            sb.append("/oat/arm64/");
            if (new File(sb.toString()).exists()) {
                StringBuilder sb2 = new StringBuilder();
                sb2.append(this.CodePath);
                sb2.append("/oat/arm64/");
                LoadFiles(sb2.toString());
            } else {
                StringBuilder sb3 = new StringBuilder();
                sb3.append(this.CodePath);
                sb3.append("/oat/arm/");
                if (new File(sb3.toString()).exists()) {
                    StringBuilder sb4 = new StringBuilder();
                    sb4.append(this.CodePath);
                    sb4.append("/oat/arm/");
                    LoadFiles(sb4.toString());
                }
            }
            Trace.traceEnd(64);
        }
    }

    public UxPerformance() {
        QLogD("UX Perf module initialized");
        this.EnablePrefetch = SystemProperties.getBoolean("vendor.perf.iop_v3.enable", false);
        this.EnableDebug = SystemProperties.getBoolean("vendor.perf.iop_v3.enable.debug", false);
    }

    private void QLogI(String msg) {
        if (this.EnableDebug) {
            Slog.i(TAG_TASKS, msg);
        }
    }

    /* access modifiers changed from: private */
    public void QLogD(String msg) {
        if (this.EnableDebug) {
            Slog.d(TAG_TASKS, msg);
        }
    }

    private void QLogV(String msg) {
        if (this.EnableDebug) {
            Slog.v(TAG_TASKS, msg);
        }
    }

    /* access modifiers changed from: private */
    public void QLogE(String msg) {
        if (this.EnableDebug) {
            Slog.e(TAG_TASKS, msg);
        }
    }

    public int perfIOPrefetchStart(int PId, String PkgName, String CodePath) {
        if (this.EnablePrefetch) {
            QLogI("DexPrefetchThread Feature is Enable ");
            this.PreDexThread = new DexPrefetchThread(CodePath);
            if (this.PreDexThread != null) {
                new Thread(this.PreDexThread).start();
            }
            return 0;
        }
        QLogI("DexPrefetchThread Feature is disabled ");
        return -1;
    }
}