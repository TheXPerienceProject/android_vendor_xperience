/*
#
# Copyright (C) 2018-2019 The XPerience Project
# Copyright (C) Qualcomm 
#
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
    private static Boolean sIsChecked = Boolean.valueOf(false);
    private static boolean sIsPlatformOrPrivApp = true;
    private static boolean sIsUntrustedDomain = false;
    private static boolean sLoaded = false;
    /* access modifiers changed from: private */
    public static IPerfManager sPerfService = null;
    /* access modifiers changed from: private */
    public static IBinder sPerfServiceBinder = null;
    private static PerfServiceDeathRecipient sPerfServiceDeathRecipient = null;
    private static final boolean sPerfServiceDisabled = false;
    private int UXE_EVENT_BINDAPP = 2;
    private int mHandle = 0;
    /* access modifiers changed from: private */
    public final Object mLock = new Object();

    private final class PerfServiceDeathRecipient implements DeathRecipient {
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

    private native int native_perf_get_feedback(int i, String str);

    private native int native_perf_hint(int i, String str, int i2, int i3);

    private native int native_perf_io_prefetch_start(int i, String str, String str2);

    private native int native_perf_io_prefetch_stop();

    private native int native_perf_lock_acq(int i, int i2, int[] iArr);

    private native int native_perf_lock_rel(int i);

    private native int native_perf_uxEngine_events(int i, int i2, String str, int i3);

    private native String native_perf_uxEngine_trigger(int i);

    static {
        try {
            System.loadLibrary("qti_performance");
        } catch (UnsatisfiedLinkError e) {
        }
    }

    public Performance() {
    }

    public Performance(Context context) {
        synchronized (Performance.class) {
            if (!sLoaded) {
                connectPerfServiceLocked();
                if (sPerfService == null) {
                    Log.e(TAG, "XPerience-Perf service is unavailable.");
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
            Log.i(TAG, "Connecting to XPerience-Perf service.");
            sPerfServiceBinder = ServiceManager.getService(PERF_SERVICE_BINDER_NAME);
            if (sPerfServiceBinder == null) {
                Log.e(TAG, "XPerience-Perf service is now down, set sPerfService as null.");
                return;
            }
            try {
                sPerfServiceDeathRecipient = new PerfServiceDeathRecipient();
                sPerfServiceBinder.linkToDeath(sPerfServiceDeathRecipient, 0);
                if (sPerfServiceBinder != null) {
                    sPerfService = Stub.asInterface(sPerfServiceBinder);
                }
            } catch (RemoteException e) {
                Log.e(TAG, "XPerience-Perf service is now down, leave sPerfService as null.");
            }
        }
    }

    public int perfLockAcquire(int duration, int... list) {
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService == null) {
                        return -1;
                    }
                    this.mHandle = sPerfService.perfLockAcquire(duration, list);
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfLockAcquire", e);
                    return -1;
                } catch (Throwable th) {
                    throw th;
                }
            }
        } else {
            this.mHandle = native_perf_lock_acq(this.mHandle, duration, list);
        }
        if (this.mHandle <= 0) {
            return -1;
        }
        return this.mHandle;
    }

    public int perfLockRelease() {
        int retValue;
        if (!sIsPlatformOrPrivApp || sIsUntrustedDomain) {
            synchronized (this.mLock) {
                try {
                    if (sPerfService != null) {
                        retValue = sPerfService.perfLockRelease();
                    } else {
                        retValue = -1;
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
                if (sPerfService != null) {
                    retValue = sPerfService.perfLockReleaseHandler(_handle);
                } else {
                    retValue = -1;
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
                    if (sPerfService == null) {
                        return -1;
                    }
                    this.mHandle = sPerfService.perfHint(hint, userDataStr, userData1, userData2);
                } catch (RemoteException e) {
                    Log.e(TAG, "Error calling perfHint", e);
                    return -1;
                } catch (Throwable th) {
                    throw th;
                }
            }
        } else {
            this.mHandle = native_perf_hint(hint, userDataStr, userData1, userData2);
        }
        if (this.mHandle <= 0) {
            return -1;
        }
        return this.mHandle;
    }

    public int perfGetFeedback(int req, String userDataStr) {
        return native_perf_get_feedback(req, userDataStr);
    }

    public int perfIOPrefetchStart(int PId, String Pkg_name, String Code_path) {
        return native_perf_io_prefetch_start(PId, Pkg_name, Code_path);
    }

    public int perfIOPrefetchStop() {
        return native_perf_io_prefetch_stop();
    }

    public int perfUXEngine_events(int opcode, int pid, String pkg_name, int lat) {
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
                } catch (Throwable th) {
                    throw th;
                }
            }
        } else {
            this.mHandle = native_perf_uxEngine_events(opcode, pid, pkg_name, lat);
        }
        if (this.mHandle <= 0) {
            return -1;
        }
        return this.mHandle;
    }

    public String perfUXEngine_trigger(int opcode) {
        return native_perf_uxEngine_trigger(opcode);
    }

    private void checkAppPlatformSigned(Context context) {
        synchronized (sIsChecked) {
            if (context != null) {
                try {
                    if (!sIsChecked.booleanValue()) {
                        PackageInfo pkg = context.getPackageManager().getPackageInfo(context.getPackageName(), 64);
                        PackageInfo sys = context.getPackageManager().getPackageInfo("android", 64);
                        boolean z = false;
                        if ((pkg != null && pkg.signatures != null && pkg.signatures.length > 0 && sys.signatures[0].equals(pkg.signatures[0])) || pkg.applicationInfo.isPrivilegedApp()) {
                            z = true;
                        }
                        sIsPlatformOrPrivApp = z;
                        sIsChecked = Boolean.valueOf(true);
                    }
                } catch (NameNotFoundException e) {
                    Log.e(TAG, "packageName is not found.");
                    sIsPlatformOrPrivApp = true;
                } catch (Throwable th) {
                    throw th;
                }
            }
        }
    }
}