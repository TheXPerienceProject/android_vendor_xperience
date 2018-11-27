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

        public DexPrefetchThread(String str) {
            this.CodePath = str;
        }

        public void LoadFiles(String str) {
            UxPerformance uxPerformance;
            int i = 0;
            String[] strArr = new String[]{"base.art", "base.odex", "base.vdex"};
            UxPerformance uxPerformance2 = UxPerformance.this;
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(" LoadFiles() path is ");
            stringBuilder.append(str);
            uxPerformance2.QLogD(stringBuilder.toString());
            while (true) {
                int i2 = i;
                if (i2 < strArr.length) {
                    StringBuilder stringBuilder2 = new StringBuilder();
                    stringBuilder2.append(str);
                    stringBuilder2.append(strArr[i2]);
                    if (new File(stringBuilder2.toString()).exists()) {
                        StringBuilder stringBuilder3;
                        try {
                            stringBuilder3 = new StringBuilder();
                            stringBuilder3.append(str);
                            stringBuilder3.append(strArr[i2]);
                            FileChannel channel = new RandomAccessFile(new File(stringBuilder3.toString()), "r").getChannel();
                            MappedByteBuffer map = channel.map(MapMode.READ_ONLY, 0, channel.size());
                            uxPerformance2 = UxPerformance.this;
                            stringBuilder = new StringBuilder();
                            stringBuilder.append("Before Is Buffer Loaded ");
                            stringBuilder.append(map.isLoaded());
                            uxPerformance2.QLogD(stringBuilder.toString());
                            uxPerformance2 = UxPerformance.this;
                            stringBuilder = new StringBuilder();
                            stringBuilder.append("File is ");
                            stringBuilder.append(str);
                            stringBuilder.append(strArr[i2]);
                            uxPerformance2.QLogD(stringBuilder.toString());
                            map.load();
                            uxPerformance2 = UxPerformance.this;
                            stringBuilder = new StringBuilder();
                            stringBuilder.append("After Is Buffer Loaded ");
                            stringBuilder.append(map.isLoaded());
                            uxPerformance2.QLogD(stringBuilder.toString());
                        } catch (FileNotFoundException e) {
                            uxPerformance = UxPerformance.this;
                            stringBuilder3 = new StringBuilder();
                            stringBuilder3.append("DexPrefetchThread Can not find file ");
                            stringBuilder3.append(strArr[i2]);
                            stringBuilder3.append("at ");
                            stringBuilder3.append(str);
                            uxPerformance.QLogE(stringBuilder3.toString());
                        } catch (IOException e2) {
                            uxPerformance = UxPerformance.this;
                            stringBuilder3 = new StringBuilder();
                            stringBuilder3.append("DexPrefetchThread IO Error file ");
                            stringBuilder3.append(strArr[i2]);
                            stringBuilder3.append("at ");
                            stringBuilder3.append(str);
                            uxPerformance.QLogE(stringBuilder3.toString());
                        }
                    }
                    i = i2 + 1;
                } else {
                    return;
                }
            }
        }

        public void run() {
            Trace.traceBegin(64, "DexPrefetchThread");
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(this.CodePath);
            stringBuilder.append("/oat/arm64/");
            if (new File(stringBuilder.toString()).exists()) {
                stringBuilder = new StringBuilder();
                stringBuilder.append(this.CodePath);
                stringBuilder.append("/oat/arm64/");
                LoadFiles(stringBuilder.toString());
            } else {
                stringBuilder = new StringBuilder();
                stringBuilder.append(this.CodePath);
                stringBuilder.append("/oat/arm/");
                if (new File(stringBuilder.toString()).exists()) {
                    stringBuilder = new StringBuilder();
                    stringBuilder.append(this.CodePath);
                    stringBuilder.append("/oat/arm/");
                    LoadFiles(stringBuilder.toString());
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

    private void QLogD(String str) {
        if (this.EnableDebug) {
            Slog.d(TAG_TASKS, str);
        }
    }

    private void QLogE(String str) {
        if (this.EnableDebug) {
            Slog.e(TAG_TASKS, str);
        }
    }

    private void QLogI(String str) {
        if (this.EnableDebug) {
            Slog.i(TAG_TASKS, str);
        }
    }

    private void QLogV(String str) {
        if (this.EnableDebug) {
            Slog.v(TAG_TASKS, str);
        }
    }

    public int perfIOPrefetchStart(int i, String str, String str2) {
        if (this.EnablePrefetch) {
            QLogI("DexPrefetchThread Feature is Enable ");
            this.PreDexThread = new DexPrefetchThread(str2);
            if (this.PreDexThread != null) {
                new Thread(this.PreDexThread).start();
            }
            return 0;
        }
        QLogI("DexPrefetchThread Feature is disabled ");
        return -1;
    }
}
