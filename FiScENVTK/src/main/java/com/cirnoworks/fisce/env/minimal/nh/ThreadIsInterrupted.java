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

import com.cirnoworks.fisce.vm.NativeHandlerTemplate;
import com.cirnoworks.fisce.vm.IThread;
import com.cirnoworks.fisce.vm.VMCriticalException;
import com.cirnoworks.fisce.vm.VMException;

public class ThreadIsInterrupted extends NativeHandlerTemplate{

	public void dealNative(int[] args, IThread thread)
			throws VMException, VMCriticalException {
		boolean clear = args[1] > 0;
		int threadHandle = args[0];
		boolean ret = context.getThreadManager().isInterrupted(threadHandle,
				clear);
		thread.pushInt(ret ? 1 : 0);
	}

	public String getUniqueName() {
		return "java/lang/Thread.isInterrupted.(Z)Z";
	}

}
