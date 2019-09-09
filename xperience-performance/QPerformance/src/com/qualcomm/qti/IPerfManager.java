/*
#
# Copyright (C) 2018-2019 The XPerience Project
# Copyright (C) Qualcomm
#
*/
package com.qualcomm.qti;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public interface IPerfManager extends IInterface {

    public static abstract class Stub extends Binder implements IPerfManager {
        private static final String DESCRIPTOR = "com.qualcomm.qti.IPerfManager";
        static final int TRANSACTION_perfGetFeedback = 4;
        static final int TRANSACTION_perfHint = 3;
        static final int TRANSACTION_perfLockAcquire = 5;
        static final int TRANSACTION_perfLockRelease = 1;
        static final int TRANSACTION_perfLockReleaseHandler = 2;
        static final int TRANSACTION_perfUXEngine_events = 6;

        private static class Proxy implements IPerfManager {
            private IBinder mRemote;

            Proxy(IBinder remote) {
                this.mRemote = remote;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public String getInterfaceDescriptor() {
                return Stub.DESCRIPTOR;
            }

            public int perfLockRelease() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    this.mRemote.transact(Stub.TRANSACTION_perfLockRelease, obtain, reply, 0);
                    reply.readException();
                    return reply.readInt();
                } finally {
                    reply.recycle();
                    obtain.recycle();
                }
            }

            public int perfLockReleaseHandler(int handle) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(handle);
                    this.mRemote.transact(Stub.TRANSACTION_perfLockReleaseHandler, obtain, reply, 0);
                    reply.readException();
                    return reply.readInt();
                } finally {
                    reply.recycle();
                    obtain.recycle();
                }
            }

            public int perfHint(int hint, String userDataStr, int userData1, int userData2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(hint);
                    obtain.writeString(userDataStr);
                    obtain.writeInt(userData1);
                    obtain.writeInt(userData2);
                    this.mRemote.transact(Stub.TRANSACTION_perfHint, obtain, reply, 0);
                    reply.readException();
                    return reply.readInt();
                } finally {
                    reply.recycle();
                    obtain.recycle();
                }
            }

            public int perfGetFeedback(int req, String userDataStr) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(req);
                    obtain.writeString(userDataStr);
                    this.mRemote.transact(Stub.TRANSACTION_perfGetFeedback, obtain, reply, 0);
                    reply.readException();
                    return reply.readInt();
                } finally {
                    reply.recycle();
                    obtain.recycle();
                }
            }

            public int perfLockAcquire(int duration, int[] list) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(duration);
                    obtain.writeIntArray(list);
                    this.mRemote.transact(Stub.TRANSACTION_perfLockAcquire, obtain, reply, 0);
                    reply.readException();
                    return reply.readInt();
                } finally {
                    reply.recycle();
                    obtain.recycle();
                }
            }

            public int perfUXEngine_events(int opcode, int pid, String pkg_name, int lat) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel reply = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(opcode);
                    obtain.writeInt(pid);
                    obtain.writeString(pkg_name);
                    obtain.writeInt(lat);
                    this.mRemote.transact(Stub.TRANSACTION_perfUXEngine_events, obtain, reply, 0);
                    reply.readException();
                    return reply.readInt();
                } finally {
                    reply.recycle();
                    obtain.recycle();
                }
            }
        }

        public Stub() {
            attachInterface(this, DESCRIPTOR);
        }

        public static IPerfManager asInterface(IBinder obj) {
            if (obj == null) {
                return null;
            }
            IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
            if (iin == null || !(iin instanceof IPerfManager)) {
                return new Proxy(obj);
            }
            return (IPerfManager) iin;
        }

        public IBinder asBinder() {
            return this;
        }

        public boolean onTransact(int code, Parcel data, Parcel reply, int flags) throws RemoteException {
            String descriptor = DESCRIPTOR;
            if (code != 1598968902) {
                switch (code) {
                    case TRANSACTION_perfLockRelease /*1*/:
                        data.enforceInterface(descriptor);
                        int _result = perfLockRelease();
                        reply.writeNoException();
                        reply.writeInt(_result);
                        return true;
                    case TRANSACTION_perfLockReleaseHandler /*2*/:
                        data.enforceInterface(descriptor);
                        int _result2 = perfLockReleaseHandler(data.readInt());
                        reply.writeNoException();
                        reply.writeInt(_result2);
                        return true;
                    case TRANSACTION_perfHint /*3*/:
                        data.enforceInterface(descriptor);
                        int _result3 = perfHint(data.readInt(), data.readString(), data.readInt(), data.readInt());
                        reply.writeNoException();
                        reply.writeInt(_result3);
                        return true;
                    case TRANSACTION_perfGetFeedback /*4*/:
                        data.enforceInterface(descriptor);
                        int _result4 = perfGetFeedback(data.readInt(), data.readString());
                        reply.writeNoException();
                        reply.writeInt(_result4);
                        return true;
                    case TRANSACTION_perfLockAcquire /*5*/:
                        data.enforceInterface(descriptor);
                        int _result5 = perfLockAcquire(data.readInt(), data.createIntArray());
                        reply.writeNoException();
                        reply.writeInt(_result5);
                        return true;
                    case TRANSACTION_perfUXEngine_events /*6*/:
                        data.enforceInterface(descriptor);
                        int _result6 = perfUXEngine_events(data.readInt(), data.readInt(), data.readString(), data.readInt());
                        reply.writeNoException();
                        reply.writeInt(_result6);
                        return true;
                    default:
                        return super.onTransact(code, data, reply, flags);
                }
            } else {
                reply.writeString(descriptor);
                return true;
            }
        }
    }

    int perfGetFeedback(int i, String str) throws RemoteException;

    int perfHint(int i, String str, int i2, int i3) throws RemoteException;

    int perfLockAcquire(int i, int[] iArr) throws RemoteException;

    int perfLockRelease() throws RemoteException;

    int perfLockReleaseHandler(int i) throws RemoteException;

    int perfUXEngine_events(int i, int i2, String str, int i3) throws RemoteException;
}
