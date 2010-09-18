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
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.cirnoworks.fisce.vm;

import java.util.BitSet;

import org.dom4j.Element;

import com.cirnoworks.fisce.vm.data.AbstractClass;
import com.cirnoworks.fisce.vm.data.ClassArray;
import com.cirnoworks.fisce.vm.data.ClassBase;
import com.cirnoworks.fisce.vm.data.ClassField;

/**
 * 
 * @author cloudee
 */
public interface IHeap {

	/**
	 * ��󴴽��Ķ����������������
	 */
	public static final int MAX_OBJECTS = 1048576;
	/**
	 * ���ľ�̬���Ĵ�С���ֽڣ�
	 */
	public static final int MAX_STATIC = 1048576;

	/**
	 * ��VMContext���ã����ѹ������󶨵��������
	 * 
	 * @param context
	 *            Ҫ�󶨵������
	 */
	void setContext(VMContext context);

	/**
	 * ��������
	 * 
	 * @param data
	 *            �����Ŀ��ڵ�
	 * @throws VMCriticalException
	 *             �����ʱ������������쳣
	 */
	void saveData(Element data) throws VMCriticalException;

	/**
	 * ��ȡ����
	 * 
	 * @param data
	 *            ��Ŵ���ȡ���ݵĽڵ�
	 * @throws VMCriticalException
	 *             ��ȡ��ʱ������������쳣
	 */
	void loadData(Element data) throws VMCriticalException;

	/**
	 * ����һ������
	 * 
	 * @param clazz
	 *            �������
	 * @return ����ľ��
	 * @throws VMException
	 *             �����˿�����������ڲ�������쳣
	 * @throws VMCriticalException
	 *             ������������ڲ��޷�������쳣
	 */
	int allocate(ClassBase clazz) throws VMException, VMCriticalException;

	/**
	 * ����һ������
	 * 
	 * @param clazz
	 *            �������
	 * @param length
	 *            ����Ĵ�С
	 * @return ����ľ��
	 * @throws VMException
	 *             �����˿�����������ڲ�������쳣
	 * @throws VMCriticalException
	 *             ������������ڲ��޷�������쳣
	 */
	int allocate(ClassArray clazz, int length) throws VMException,
			VMCriticalException;

	/**
	 * ��¡һ������
	 * 
	 * @param handle
	 *            ����¡�Ķ���ľ��
	 * @return �¶���ľ��
	 * @throws VMException
	 * @throws VMCriticalException
	 */
	int clone(int handle) throws VMException, VMCriticalException;

	/**
	 * �����ַ�������Ӧ���ַ��������ľ����<br />
	 * �����������û�ж�Ӧ���ַ����������ڳ������д���һ����
	 * 
	 * @param content
	 *            �ַ���������
	 * @return �������е��ַ������
	 * @throws VMException
	 * @throws VMCriticalException
	 */
	int getInternString(String content) throws VMException, VMCriticalException;

	/**
	 * ���һ���������ڵ����class id��(class id����com.cirnoworks.fisce.vm.VMContext�б�ӳ�䵽��)
	 * 
	 * @param handle
	 *            ����ľ��
	 * @return ���class id��
	 */
	int getClass(int handle) throws VMException;

	/**
	 * ��ȡ����ĳ���
	 * 
	 * @param handle
	 *            �������ڵľ��
	 * @return ����ĳ���
	 * @throws VMException
	 */
	int getArrayLength(int handle) throws VMException;

	/**
	 * ��ö���ĳ�Ա�����Ĳ���ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա�����Ĳ���ֵ
	 * @throws VMException
	 */
	boolean getFieldBoolean(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������byteֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������byteֵ
	 * @throws VMException
	 */
	byte getFieldByte(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������shortֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������shortֵ
	 * @throws VMException
	 */
	short getFieldShort(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������charֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������charֵ
	 * @throws VMException
	 */
	char getFieldChar(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������intֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������intֵ
	 * @throws VMException
	 */
	int getFieldInt(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������longֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������longֵ
	 * @throws VMException
	 */
	long getFieldLong(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������floatֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������floatֵ
	 * @throws VMException
	 */
	float getFieldFloat(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա������doubleֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա������doubleֵ
	 * @throws VMException
	 */
	double getFieldDouble(int handle, ClassField field) throws VMException;

	/**
	 * ��ö���ĳ�Ա�����ľ��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @return ��Ա�����ľ��
	 * @throws VMException
	 */
	int getFieldHandle(int handle, ClassField field) throws VMException;

	int getFieldAbs(int handle, int pos) throws VMException;

	long getFieldAbsWide(int handle, int pos) throws VMException;

	/**
	 * �趨�����Ա������ֵ��boolean��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldBoolean(int handle, ClassField field, boolean value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��byte��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldByte(int handle, ClassField field, byte value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��short��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldShort(int handle, ClassField field, short value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��char��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldChar(int handle, ClassField field, char value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��int��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldInt(int handle, ClassField field, int value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��long��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldLong(int handle, ClassField field, long value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��float��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldFloat(int handle, ClassField field, float value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��double��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldDouble(int handle, ClassField field, double value)
			throws VMException;

	/**
	 * �趨�����Ա������ֵ��handle��
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param field
	 *            ��Ա����
	 * @param value
	 *            ֵ
	 * @throws VMException
	 */
	void putFieldHandle(int handle, ClassField field, int value)
			throws VMException;

	void putFieldAbs(int handle, int pos, int value)
			throws VMCriticalException, VMException;

	void putFieldAbsWide(int handle, int pos, long value)
			throws VMCriticalException, VMException;

	/**
	 * ȡboolean�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	boolean getArrayBoolean(int handle, int index) throws VMException;

	/**
	 * ȡbyte�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	byte getArrayByte(int handle, int index) throws VMException;

	/**
	 * ȡshort�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	short getArrayShort(int handle, int index) throws VMException;

	/**
	 * ȡchar�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	char getArrayChar(int handle, int index) throws VMException;

	/**
	 * ȡint�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	int getArrayInt(int handle, int index) throws VMException;

	/**
	 * ȡlong�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	long getArrayLong(int handle, int index) throws VMException;

	/**
	 * ȡfloat�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	float getArrayFloat(int handle, int index) throws VMException;

	/**
	 * ȡdouble�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	double getArrayDouble(int handle, int index) throws VMException;

	/**
	 * ȡObject�����е�ֵ
	 * 
	 * @param handle
	 *            ����ľ��
	 * @param index
	 *            λ��
	 * @return ֵ
	 * @throws VMException
	 */
	int getArrayHandle(int handle, int index) throws VMException;

	void putArrayBoolean(int handle, int index, boolean value)
			throws VMException;

	void putArrayByte(int handle, int index, byte value) throws VMException;

	void putArrayShort(int handle, int index, short value) throws VMException;

	void putArrayChar(int handle, int index, char value) throws VMException;

	void putArrayInt(int handle, int index, int value) throws VMException;

	void putArrayLong(int handle, int index, long value) throws VMException;

	void putArrayFloat(int handle, int index, float value) throws VMException;

	void putArrayDouble(int handle, int index, double value) throws VMException;

	void putArrayHandle(int handle, int index, int value) throws VMException;

	/**
	 * �������������
	 * @param srcHandle Դ����
	 * @param srcOfs Դ�������ʼ��
	 * @param destHandle Ŀ������
	 * @param destOfs Ŀ���������ʼ��
	 * @param count Ҫ���Ƶĳ���
	 * @throws VMException
	 */
	void arrayCopy(int srcHandle, int srcOfs, int destHandle, int destOfs,
			int count) throws VMException;

	/**
	 * ������侲̬�ռ䣨�������ʱ����VM���ã�
	 * @param clazz Ҫ����ռ����
	 * @throws VMException
	 */
	void initStaticAreaForClass(AbstractClass clazz) throws VMException;

	/**
	 * ȡ�ྲ̬�ռ���׵�ַ
	 * @param clazz ��
	 * @return �ྲ̬�ռ���׵�ַ
	 * @throws VMException
	 */
	int getClazzStaticPos(AbstractClass clazz) throws VMException;

	public boolean getStaticBoolean(ClassField field) throws VMException;

	public byte getStaticByte(ClassField field) throws VMException;

	public char getStaticShort(ClassField field) throws VMException;

	public char getStaticChar(ClassField field) throws VMException;

	public int getStaticInt(ClassField field) throws VMException;

	public long getStaticLong(ClassField field) throws VMException;

	public float getStaticFloat(ClassField field) throws VMException;

	public double getStaticDouble(ClassField field) throws VMException;

	public int getStaticAbs(int pos) throws VMException;

	public long getStaticAbsWide(int pos) throws VMException;

	public void setStaticBoolean(ClassField field, boolean value)
			throws VMException;

	public void setStaticByte(ClassField field, byte value) throws VMException;

	public void setStaticShort(ClassField field, char value) throws VMException;

	public void setStaticChar(ClassField field, char value) throws VMException;

	public void setStaticInt(ClassField field, int value) throws VMException;

	public void setStaticLong(ClassField field, long value) throws VMException;

	public void setStaticFloat(ClassField field, float value)
			throws VMException;

	public void setStaticDouble(ClassField field, double value)
			throws VMException;

	public void setStaticAbs(int pos, int value) throws VMException;

	public void setStaticAbsWide(int pos, long value) throws VMException;

	/**
	 * ȡ�ַ�����������ľ�� <br />
	 * ����ַ������������ھʹ���һ��
	 * @param str �ַ���
	 * @return ��Ӧ���ַ��������ľ��
	 * @throws VMException
	 * @throws VMCriticalException
	 */
	public int getLiteral(String str) throws VMException, VMCriticalException;

	/**
	 * ���ַ���������ȡ���ַ���
	 * @param handle �ַ�������ľ��
	 * @return �ַ���
	 * @throws VMException
	 * @throws VMCriticalException
	 */
	public String getString(int handle) throws VMException, VMCriticalException;

	/**
	 * ���ַ�����������з���һ������
	 * @param content �ַ���
	 * @return ����Ķ�����
	 * @throws VMException
	 * @throws VMCriticalException
	 */
	public int putString(String content) throws VMException,
			VMCriticalException;

	/**
	 * ����Ƿ�Ϸ�
	 * @param handle ���
	 * @return ����Ƿ�Ϸ�
	 */
	boolean isHandleValid(int handle);

	/**
	 * ɨ������ݣ�����һ������Ƿ��õ���λ��
	 * @return λ����ÿһλ��ʾһ����Ӧ�ľ���ǲ��Ǳ��õ�
	 * @throws VMCriticalException
	 */
	BitSet scanHeap() throws VMCriticalException;

	/**
	 * �����ռ����ͷŵ���ʹ�õľ���Ͷ�Ӧ���ڴ�ռ�
	 * @throws VMCriticalException
	 */
	void gc() throws VMCriticalException;
}
