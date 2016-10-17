/*
 * Copyright (c) 2016 Paranoid Android
 *
 */

package mx.xperience.power;

import android.util.Log;

public final class ShutdownXPe {
    private static final String TAG = "XPerienceShutdown";

    public void rebootOrShutdown(boolean isreboot, String rebootreason) {
        Log.i(TAG, "Triggered!");
        try {
            if (com.qti.server.power.SubSystemShutdown.shutdown() != 0) {
                Log.e(TAG, "Failed to shutdown modem.");
            } else {
                Log.i(TAG, "Modem shutdown successful.");
            }
        } catch (Exception e) {
            Log.w(TAG, "Couldn't execute modem shutdown. Skipping...");
        }
    }
}
