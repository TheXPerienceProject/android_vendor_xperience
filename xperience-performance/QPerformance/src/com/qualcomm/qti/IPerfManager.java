/*
#
# Copyright (C) 2018-2021 The XPerience Project
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
    int perfHint(int i, String str, int i2, int i3, int i4) throws RemoteException;

    int perfLockAcqAndRelease(int i, int i2, int i3, int i4, int[] iArr) throws RemoteException;

    int perfLockAcquire(int i, int[] iArr) throws RemoteException;

    int perfLockRelease() throws RemoteException;

    int perfLockReleaseHandler(int i) throws RemoteException;

    int perfUXEngine_events(int i, int i2, String str, int i3) throws RemoteException;

    int setClientBinder(IBinder iBinder) throws RemoteException;

    public static class Default implements IPerfManager {
        @Override // com.qualcomm.qti.IPerfManager
        public int perfLockRelease() throws RemoteException {
            return 0;
        }

        @Override // com.qualcomm.qti.IPerfManager
        public int perfLockReleaseHandler(int handle) throws RemoteException {
            return 0;
        }

        @Override // com.qualcomm.qti.IPerfManager
        public int perfHint(int hint, String userDataStr, int userData1, int userData2, int tid) throws RemoteException {
            return 0;
        }

        @Override // com.qualcomm.qti.IPerfManager
        public int perfLockAcquire(int duration, int[] list) throws RemoteException {
            return 0;
        }

        @Override // com.qualcomm.qti.IPerfManager
        public int perfUXEngine_events(int opcode, int pid, String pkg_name, int lat) throws RemoteException {
            return 0;
        }

        @Override // com.qualcomm.qti.IPerfManager
        public int setClientBinder(IBinder client) throws RemoteException {
            return 0;
        }

        @Override // com.qualcomm.qti.IPerfManager
        public int perfLockAcqAndRelease(int handle, int duration, int numArgs, int reserveNumArgs, int[] list) throws RemoteException {
            return 0;
        }

        public IBinder asBinder() {
            return null;
        }
    }

    public static abstract class Stub extends Binder implements IPerfManager {
        private static final String DESCRIPTOR = "com.qualcomm.qti.IPerfManager";
        static final int TRANSACTION_perfHint = 3;
        static final int TRANSACTION_perfLockAcqAndRelease = 7;
        static final int TRANSACTION_perfLockAcquire = 4;
        static final int TRANSACTION_perfLockRelease = 1;
        static final int TRANSACTION_perfLockReleaseHandler = 2;
        static final int TRANSACTION_perfUXEngine_events = 5;
        static final int TRANSACTION_setClientBinder = 6;

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

        @Override // android.os.Binder
        public boolean onTransact(int code, Parcel data, Parcel reply, int flags) throws RemoteException {
            if (code != 1598968902) {
                switch (code) {
                    case TRANSACTION_perfLockRelease /*{ENCODED_INT: 1}*/:
                        data.enforceInterface(DESCRIPTOR);
                        int _result = perfLockRelease();
                        reply.writeNoException();
                        reply.writeInt(_result);
                        return true;
                    case 2:
                        data.enforceInterface(DESCRIPTOR);
                        int _result2 = perfLockReleaseHandler(data.readInt());
                        reply.writeNoException();
                        reply.writeInt(_result2);
                        return true;
                    case TRANSACTION_perfHint /*{ENCODED_INT: 3}*/:
                        data.enforceInterface(DESCRIPTOR);
                        int _result3 = perfHint(data.readInt(), data.readString(), data.readInt(), data.readInt(), data.readInt());
                        reply.writeNoException();
                        reply.writeInt(_result3);
                        return true;
                    case TRANSACTION_perfLockAcquire /*{ENCODED_INT: 4}*/:
                        data.enforceInterface(DESCRIPTOR);
                        int _result4 = perfLockAcquire(data.readInt(), data.createIntArray());
                        reply.writeNoException();
                        reply.writeInt(_result4);
                        return true;
                    case TRANSACTION_perfUXEngine_events /*{ENCODED_INT: 5}*/:
                        data.enforceInterface(DESCRIPTOR);
                        int _result5 = perfUXEngine_events(data.readInt(), data.readInt(), data.readString(), data.readInt());
                        reply.writeNoException();
                        reply.writeInt(_result5);
                        return true;
                    case TRANSACTION_setClientBinder /*{ENCODED_INT: 6}*/:
                        data.enforceInterface(DESCRIPTOR);
                        int _result6 = setClientBinder(data.readStrongBinder());
                        reply.writeNoException();
                        reply.writeInt(_result6);
                        return true;
                    case TRANSACTION_perfLockAcqAndRelease /*{ENCODED_INT: 7}*/:
                        data.enforceInterface(DESCRIPTOR);
                        int _result7 = perfLockAcqAndRelease(data.readInt(), data.readInt(), data.readInt(), data.readInt(), data.createIntArray());
                        reply.writeNoException();
                        reply.writeInt(_result7);
                        return true;
                    default:
                        return super.onTransact(code, data, reply, flags);
                }
            } else {
                reply.writeString(DESCRIPTOR);
                return true;
            }
        }

        private static class Proxy implements IPerfManager {
            public static IPerfManager sDefaultImpl;
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

            @Override // com.qualcomm.qti.IPerfManager
            public int perfLockRelease() throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    if (!this.mRemote.transact(Stub.TRANSACTION_perfLockRelease, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().perfLockRelease();
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }

            @Override // com.qualcomm.qti.IPerfManager
            public int perfLockReleaseHandler(int handle) throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    _data.writeInt(handle);
                    if (!this.mRemote.transact(2, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().perfLockReleaseHandler(handle);
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }

            @Override // com.qualcomm.qti.IPerfManager
            public int perfHint(int hint, String userDataStr, int userData1, int userData2, int tid) throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    _data.writeInt(hint);
                    _data.writeString(userDataStr);
                    _data.writeInt(userData1);
                    _data.writeInt(userData2);
                    _data.writeInt(tid);
                    if (!this.mRemote.transact(Stub.TRANSACTION_perfHint, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().perfHint(hint, userDataStr, userData1, userData2, tid);
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }

            @Override // com.qualcomm.qti.IPerfManager
            public int perfLockAcquire(int duration, int[] list) throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    _data.writeInt(duration);
                    _data.writeIntArray(list);
                    if (!this.mRemote.transact(Stub.TRANSACTION_perfLockAcquire, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().perfLockAcquire(duration, list);
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }

            @Override // com.qualcomm.qti.IPerfManager
            public int perfUXEngine_events(int opcode, int pid, String pkg_name, int lat) throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    _data.writeInt(opcode);
                    _data.writeInt(pid);
                    _data.writeString(pkg_name);
                    _data.writeInt(lat);
                    if (!this.mRemote.transact(Stub.TRANSACTION_perfUXEngine_events, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().perfUXEngine_events(opcode, pid, pkg_name, lat);
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }

            @Override // com.qualcomm.qti.IPerfManager
            public int setClientBinder(IBinder client) throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    _data.writeStrongBinder(client);
                    if (!this.mRemote.transact(Stub.TRANSACTION_setClientBinder, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().setClientBinder(client);
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }

            @Override // com.qualcomm.qti.IPerfManager
            public int perfLockAcqAndRelease(int handle, int duration, int numArgs, int reserveNumArgs, int[] list) throws RemoteException {
                Parcel _data = Parcel.obtain();
                Parcel _reply = Parcel.obtain();
                try {
                    _data.writeInterfaceToken(Stub.DESCRIPTOR);
                    _data.writeInt(handle);
                    _data.writeInt(duration);
                    _data.writeInt(numArgs);
                    _data.writeInt(reserveNumArgs);
                    _data.writeIntArray(list);
                    if (!this.mRemote.transact(Stub.TRANSACTION_perfLockAcqAndRelease, _data, _reply, 0) && Stub.getDefaultImpl() != null) {
                        return Stub.getDefaultImpl().perfLockAcqAndRelease(handle, duration, numArgs, reserveNumArgs, list);
                    }
                    _reply.readException();
                    int _result = _reply.readInt();
                    _reply.recycle();
                    _data.recycle();
                    return _result;
                } finally {
                    _reply.recycle();
                    _data.recycle();
                }
            }
        }

        public static boolean setDefaultImpl(IPerfManager impl) {
            if (Proxy.sDefaultImpl != null) {
                throw new IllegalStateException("setDefaultImpl() called twice");
            } else if (impl == null) {
                return false;
            } else {
                Proxy.sDefaultImpl = impl;
                return true;
            }
        }

        public static IPerfManager getDefaultImpl() {
            return Proxy.sDefaultImpl;
        }
    }
}
