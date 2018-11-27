/*
 * Copyright (c) 2018 The XPerience Project
 *
 */
package com.qualcomm.qti;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.IBinder;
import android.os.IBinder.DeathRecipient;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.util.Log;
import com.qualcomm.qti.IPerfManager.Stub;

public class Performance {
    private static final boolean DEBUG = false;
    private static final String PERF_SERVICE_BINDER_NAME = "vendor.perfservice";
    public static final int REQUEST_FAILED = -1;
    public static final int REQUEST_SUCCEEDED = 0;
    private static final String TAG = "XPerience-Perf";
    private static boolean sLoaded = DEBUG;
    private static IPerfManager sPerfService;
    private static IBinder sPerfServiceBinder;
    private static PerfServiceDeathRecipient sPerfServiceDeathRecipient;
    private static final boolean sPerfServiceDisabled = false;
    private int UXE_EVENT_BINDAPP = 2;
    private int mHandle = 0;
    private boolean mIsPlatformOrPrivApp = true;
    private final Object mLock = new Object();

    private final class PerfServiceDeathRecipient implements DeathRecipient {
        private PerfServiceDeathRecipient() {
        }

        public void binderDied() {
            synchronized (Performance.this.mLock) {
                Log.e(Performance.TAG, "Perf Service died.");
                if (Performance.sPerfServiceBinder != null) {
                    Performance.sPerfServiceBinder.unlinkToDeath(this, 0);
                }
                Performance.sPerfServiceBinder = null;
                Performance.sPerfService = null;
            }
        }
    }

    static {
        try {
            System.loadLibrary("qti_performance");
        } catch (UnsatisfiedLinkError e) {
        }
    }

    public Performance(Context context) {
        synchronized (Performance.class) {
            try {
                if (!sLoaded) {
                    connectPerfServiceLocked();
                    if (sPerfService == null) {
                        Log.e(TAG, "Perf service is unavailable.");
                    } else {
                        sLoaded = true;
                    }
                }
            } catch (Throwable th) {
                Class cls = Performance.class;
            }
        }
        checkAppPlatformSigned(context);
    }

    private void checkAppPlatformSigned(Context context) {
        boolean z = DEBUG;
        if (context != null) {
            try {
                PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 64);
                PackageInfo packageInfo2 = context.getPackageManager().getPackageInfo("android", 64);
                if ((packageInfo != null && packageInfo.signatures != null && packageInfo.signatures.length > 0 && packageInfo2.signatures[0].equals(packageInfo.signatures[0])) || packageInfo.applicationInfo.isPrivilegedApp()) {
                    z = true;
                }
                this.mIsPlatformOrPrivApp = z;
            } catch (NameNotFoundException e) {
                Log.e(TAG, "packageName is not found.");
                this.mIsPlatformOrPrivApp = true;
            }
        }
    }

    private void connectPerfServiceLocked() {
        if (sPerfService == null) {
            Log.i(TAG, "Connecting to perf service.");
            sPerfServiceBinder = ServiceManager.getService(PERF_SERVICE_BINDER_NAME);
            if (sPerfServiceBinder == null) {
                Log.e(TAG, "Perf service is now down, set sPerfService as null.");
                return;
            }
            try {
                sPerfServiceDeathRecipient = new PerfServiceDeathRecipient();
                sPerfServiceBinder.linkToDeath(sPerfServiceDeathRecipient, 0);
                if (sPerfServiceBinder != null) {
                    sPerfService = Stub.asInterface(sPerfServiceBinder);
                }
            } catch (RemoteException e) {
                Log.e(TAG, "Perf service is now down, leave sPerfService as null.");
            }
        }
    }

    private native int native_perf_hint(int i, String str, int i2, int i3);

    private native int native_perf_io_prefetch_start(int i, String str, String str2);

    private native int native_perf_io_prefetch_stop();

    private native int native_perf_lock_acq(int i, int i2, int[] iArr);

    private native int native_perf_lock_rel(int i);

    private native int native_perf_uxEngine_events(int i, int i2, String str, int i3);

    private native String native_perf_uxEngine_trigger(int i);

    public int perfHint(int i, String str, int i2, int i3) {
        if (this.mIsPlatformOrPrivApp) {
            this.mHandle = native_perf_hint(i, str, i2, i3);
        } else {
            synchronized (this.mLock) {
                try {
                    if (sPerfService != null) {
                        this.mHandle = sPerfService.perfHint(i, str, i2, i3);
                    } else {
                        return -1;
                    }
                } catch (Throwable e) {
                    Log.e(TAG, "Error calling perfHint", e);
                    return -1;
                }
            }
        }
        return this.mHandle <= 0 ? -1 : this.mHandle;
    }

    public int perfIOPrefetchStart(int i, String str, String str2) {
        return native_perf_io_prefetch_start(i, str, str2);
    }

    public int perfIOPrefetchStop() {
        return native_perf_io_prefetch_stop();
    }

    public int perfLockAcquire(int i, int... iArr) {
        if (this.mIsPlatformOrPrivApp) {
            this.mHandle = native_perf_lock_acq(this.mHandle, i, iArr);
        } else {
            synchronized (this.mLock) {
                try {
                    if (sPerfService != null) {
                        this.mHandle = sPerfService.perfLockAcquire(i, iArr);
                    } else {
                        return -1;
                    }
                } catch (Throwable e) {
                    Log.e(TAG, "Error calling perfLockAcquire", e);
                    return -1;
                }
            }
        }
        return this.mHandle <= 0 ? -1 : this.mHandle;
    }

    public int perfLockRelease() {
        int i = -1;
        if (this.mIsPlatformOrPrivApp) {
            i = native_perf_lock_rel(this.mHandle);
            this.mHandle = 0;
            return i;
        }
        synchronized (this.mLock) {
            try {
                if (sPerfService != null) {
                    i = sPerfService.perfLockRelease();
                }
            } catch (Throwable e) {
                Log.e(TAG, "Error calling perfLockRelease", e);
                return -1;
            }
        }
        return i;
    }

    /* Releasse locked handlers */
    public int perfLockReleaseHandler(int i) {
        int i2 = -1;
        if (this.mIsPlatformOrPrivApp) {
            return native_perf_lock_rel(i);
        }
        synchronized (this.mLock) {
            try {
                if (sPerfService != null) {
                    i2 = sPerfService.perfLockReleaseHandler(i);
                }
            } catch (Throwable e) {
                Log.e(TAG, "Error calling perfLockRelease(handle)", e);
                return -1;
            }
        }
        return i2;
    }

    public int perfUXEngine_events(int i, int i2, String str, int i3) {
        if (i == this.UXE_EVENT_BINDAPP) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService != null) {
                        this.mHandle = sPerfService.perfUXEngine_events(i, i2, str, i3);
                    } else {
                        return -1;
                    }
                } catch (Throwable e) {
                    Log.e(TAG, "Error calling perfHint", e);
                    return -1;
                }
            }
        }
        this.mHandle = native_perf_uxEngine_events(i, i2, str, i3);
        return this.mHandle <= 0 ? -1 : this.mHandle;
    }

    public String perfUXEngine_trigger(int i) {
        return native_perf_uxEngine_trigger(i);
    }
}
