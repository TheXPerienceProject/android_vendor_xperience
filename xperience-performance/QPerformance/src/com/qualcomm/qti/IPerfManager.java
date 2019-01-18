/*
 * Copyright (c) 2018 The XPerience Project
 *
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

        static final int TRANSACTION_perfLockRelease = 1;
        static final int TRANSACTION_perfLockReleaseHandler = 2;
        static final int TRANSACTION_perfHint = 3;
        static final int TRANSACTION_perfLockAcquire = 4;
        static final int TRANSACTION_perfUXEngine_events = 5;
        static final int TRANSACTION_perfGetFeedback = 6;

        private static class Proxy implements IPerfManager {
            private IBinder mRemote;

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public String getInterfaceDescriptor() {
                return Stub.DESCRIPTOR;
            }

            public int perfGetFeedback(int i, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    this.mRemote.transact(Stub.TRANSACTION_perfGetFeedback, obtain, obtain2, 0);
                    obtain2.readException();
                    int readInt = obtain2.readInt();
                    return readInt;
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int perfHint(int i, String str, int i2, int i3) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    obtain.writeInt(i2);
                    obtain.writeInt(i3);
                    this.mRemote.transact(Stub.TRANSACTION_perfHint, obtain, obtain2, 0);
                    obtain2.readException();
                    int readInt = obtain2.readInt();
                    return readInt;
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int perfLockAcquire(int i, int[] iArr) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeIntArray(iArr);
                    this.mRemote.transact(Stub.TRANSACTION_perfLockAcquire, obtain, obtain2, 0);
                    obtain2.readException();
                    int readInt = obtain2.readInt();
                    return readInt;
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int perfLockRelease() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    this.mRemote.transact(Stub.TRANSACTION_perfLockRelease, obtain, obtain2, 0);
                    obtain2.readException();
                    int readInt = obtain2.readInt();
                    return readInt;
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int perfLockReleaseHandler(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(Stub.TRANSACTION_perfLockReleaseHandler, obtain, obtain2, 0);
                    obtain2.readException();
                    int readInt = obtain2.readInt();
                    return readInt;
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int perfUXEngine_events(int i, int i2, String str, int i3) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(Stub.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    obtain.writeString(str);
                    obtain.writeInt(i3);
                    this.mRemote.transact(Stub.TRANSACTION_perfUXEngine_events, obtain, obtain2, 0);
                    obtain2.readException();
                    int readInt = obtain2.readInt();
                    return readInt;
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }
        }

        public Stub() {
            attachInterface(this, DESCRIPTOR);
        }

        public static IPerfManager asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(DESCRIPTOR);
            return (queryLocalInterface == null || !(queryLocalInterface instanceof IPerfManager)) ? new Proxy(iBinder) : (IPerfManager) queryLocalInterface;
        }

        public IBinder asBinder() {
            return this;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i != 1598968902) {
                int perfLockRelease;
                switch (i) {
                    case TRANSACTION_perfLockRelease /*1*/:
                        parcel.enforceInterface(DESCRIPTOR);
                        perfLockRelease = perfLockRelease();
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockRelease);
                        return true;
                    case TRANSACTION_perfLockReleaseHandler /*2*/:
                        parcel.enforceInterface(DESCRIPTOR);
                        perfLockRelease = perfLockReleaseHandler(parcel.readInt());
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockRelease);
                        return true;
                    case TRANSACTION_perfHint /*3*/:
                        parcel.enforceInterface(DESCRIPTOR);
                        perfLockRelease = perfHint(parcel.readInt(), parcel.readString(), parcel.readInt(), parcel.readInt());
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockRelease);
                        return true;
                    case TRANSACTION_perfLockAcquire /*4*/:
                        parcel.enforceInterface(DESCRIPTOR);
                        perfLockRelease = perfLockAcquire(parcel.readInt(), parcel.createIntArray());
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockRelease);
                        return true;
                    case TRANSACTION_perfUXEngine_events /*5*/:
                        parcel.enforceInterface(DESCRIPTOR);
                        perfLockRelease = perfUXEngine_events(parcel.readInt(), parcel.readInt(), parcel.readString(), parcel.readInt());
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockRelease);
                        return true;
                    case TRANSACTION_perfGetFeedback /*6*/:
                        parcel.enforceInterface(DESCRIPTOR);
                        perfLockRelease = perfGetFeedback(parcel.readInt(), parcel.readString());
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockRelease);
                        return true;
                    default:
                        return super.onTransact(i, parcel, parcel2, i2);
                }
            }
            parcel2.writeString(DESCRIPTOR);
            return true;
        }
    }

    int perfGetFeedback(int i, String str) throws RemoteException;

    int perfHint(int i, String str, int i2, int i3) throws RemoteException;

    int perfLockAcquire(int i, int[] iArr) throws RemoteException;

    int perfLockRelease() throws RemoteException;

    int perfLockReleaseHandler(int i) throws RemoteException;

    int perfUXEngine_events(int i, int i2, String str, int i3) throws RemoteException;
}
