/**
 *  Copyright 2010 Yuxuan Huang. All rights reserved.
 *  
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.cirnoworks.fisce.env.minimal.nh;

import java.io.UnsupportedEncodingException;

import com.cirnoworks.fisce.intf.IHeap;
import com.cirnoworks.fisce.intf.IThread;
import com.cirnoworks.fisce.intf.NativeHandlerTemplate;
import com.cirnoworks.fisce.intf.VMCriticalException;
import com.cirnoworks.fisce.intf.VMException;
import com.cirnoworks.fisce.vm.data.ClassArray;

public class FiScEVMDecode extends NativeHandlerTemplate{

	public void dealNative(int[] args, IThread thread)
			throws VMException, VMCriticalException {
		IHeap heap = context.getHeap();
		int encodeHandle = args[0];
		int content = args[1];
		int ofs = args[2];
		int len = args[3];
		String encode = heap.getString(encodeHandle);
		byte[] bs = new byte[len];
		for (int i = 0; i < len; i++) {
			bs[i] = context.getHeap().getArrayByte(content, i + ofs);
		}
		try {
			char[] cs = new String(bs, encode).toCharArray();
			int retHandle = heap.allocate((ClassArray) context.getClass("[C"),
					bs.length);
			for (int i = 0, max = cs.length; i < max; i++) {
				heap.putArrayChar(retHandle, i, cs[i]);
			}
			thread.nativeReturnHandle(retHandle);
		} catch (UnsupportedEncodingException e) {
			throw new VMException("java/io/UnsupportedEncodingException",
					encode);
		}
	}

	public String getUniqueName() {
		return "com/cirnoworks/fisce/privat/FiScEVM.decode.(Ljava/lang/String;[BII)[C";
	}

}