/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package java.lang.reflect;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import org.apache.harmony.beans.internal.nls.Messages;
import org.apache.harmony.luni.internal.reflect.ProxyClassFile;

/**
 * {@code Proxy} defines methods for creating dynamic proxy classes and
 * instances. A proxy class implements a declared set of interfaces and
 * delegates method invocations to an {@code InvocationHandler}.
 * 
 * @see InvocationHandler
 * @since 1.3
 */
public class Proxy implements Serializable {

	private static final long serialVersionUID = -2222568056686623797L;

	// maps class loaders to created classes by interface names
	private static final Map<ClassLoader, Map<String, Class<?>>> loaderCache = new HashMap<ClassLoader, Map<String, Class<?>>>();

	// to find previously created types
	private static final Map<Class<?>, String> proxyCache = new HashMap<Class<?>, String>();

	private static int NextClassNameIndex = 0;

	/**
	 * The invocation handler on which the method calls are dispatched.
	 */
	protected InvocationHandler h;

	private Proxy() {
	}

	/**
	 * Constructs a new {@code Proxy} instance with the specified invocation
	 * handler.
	 * 
	 * @param h
	 *            the invocation handler for the newly created proxy
	 */
	protected Proxy(InvocationHandler h) {
		this.h = h;
	}

	/**
	 * Returns the dynamically built {@code Class} for the specified interfaces.
	 * Creates a new {@code Class} when necessary. The order of the interfaces
	 * is relevant. Invocations of this method with the same interfaces but
	 * different order result in different generated classes. The interfaces
	 * must be visible from the supplied class loader; no duplicates are
	 * permitted. All non-public interfaces must be defined in the same package.
	 * 
	 * @param loader
	 *            the class loader that will define the proxy class
	 * @param interfaces
	 *            a list of {@code Class} objects, each one identifying an
	 *            interface that will be implemented by the returned proxy class
	 * @return a proxy class that implements all of the interfaces referred to
	 *         in the contents of {@code interfaces}
	 * @throws IllegalArgumentException
	 *             if any of the interface restrictions are violated
	 * @throws NullPointerException
	 *             if either {@code interfaces} or any of its elements are
	 *             {@code null}
	 */
	public static Class<?> getProxyClass(ClassLoader loader,
			Class<?>... interfaces) throws IllegalArgumentException {
		// check that interfaces are a valid array of visible interfaces
		if (interfaces == null) {
			throw new NullPointerException();
		}
		String commonPackageName = null;
		for (int i = 0, length = interfaces.length; i < length; i++) {
			Class<?> next = interfaces[i];
			if (next == null) {
				throw new NullPointerException();
			}
			String name = next.getName();
			if (!next.isInterface()) {
				throw new IllegalArgumentException(Messages.getString(
						"luni.50", name)); //$NON-NLS-1$
			}
			if (loader != next.getClassLoader()) {
				try {
					if (next != Class.forName(name, false, loader)) {
						throw new IllegalArgumentException(Messages.getString(
								"luni.51", name)); //$NON-NLS-1$
					}
				} catch (ClassNotFoundException ex) {
					throw new IllegalArgumentException(Messages.getString(
							"luni.51", //$NON-NLS-1$
							name));
				}
			}
			for (int j = i + 1; j < length; j++) {
				if (next == interfaces[j]) {
					throw new IllegalArgumentException(Messages.getString(
							"luni.52", //$NON-NLS-1$
							name));
				}
			}
			if (!Modifier.isPublic(next.getModifiers())) {
				int last = name.lastIndexOf('.');
				String p = last == -1 ? "" : name.substring(0, last); //$NON-NLS-1$
				if (commonPackageName == null) {
					commonPackageName = p;
				} else if (!commonPackageName.equals(p)) {
					throw new IllegalArgumentException(
							Messages.getString("luni.53")); //$NON-NLS-1$
				}
			}
		}

		// search cache for matching proxy class using the class loader
		synchronized (loaderCache) {
			Map<String, Class<?>> interfaceCache = loaderCache.get(loader);
			if (interfaceCache == null) {
				loaderCache.put(loader,
						(interfaceCache = new HashMap<String, Class<?>>()));
			}

			String interfaceKey = ""; //$NON-NLS-1$
			if (interfaces.length == 1) {
				interfaceKey = interfaces[0].getName();
			} else {
				StringBuilder names = new StringBuilder();
				for (int i = 0, length = interfaces.length; i < length; i++) {
					names.append(interfaces[i].getName());
					names.append(' ');
				}
				interfaceKey = names.toString();
			}

			Class<?> ref = interfaceCache.get(interfaceKey);
			if (ref == null) {
				String nextClassName = "$Proxy" + NextClassNameIndex++; //$NON-NLS-1$
				if (commonPackageName != null && commonPackageName.length() > 0) {
					nextClassName = commonPackageName + "." + nextClassName; //$NON-NLS-1$
				}
				byte[] classFileBytes = ProxyClassFile.generateBytes(
						nextClassName, interfaces);
				ref = defineClassImpl(loader, nextClassName.replace('.', '/'),
						classFileBytes);
				// Need a weak reference to the class so it can
				// be unloaded if the class loader is discarded
				interfaceCache.put(interfaceKey, ref);
				synchronized (proxyCache) {
					// the value is unused
					proxyCache.put(ref, ""); //$NON-NLS-1$
				}
			} else {
				assert ref != null : "\ninterfaceKey=\"" + interfaceKey + "\""
						+ "\nloaderCache=\"" + loaderCache + "\""
						+ "\nintfCache=\"" + interfaceCache + "\""
						+ "\nproxyCache=\"" + proxyCache + "\"";
			}
			return ref;
		}
	}

	/**
	 * Returns an instance of the dynamically built class for the specified
	 * interfaces. Method invocations on the returned instance are forwarded to
	 * the specified invocation handler. The interfaces must be visible from the
	 * supplied class loader; no duplicates are permitted. All non-public
	 * interfaces must be defined in the same package.
	 * 
	 * @param loader
	 *            the class loader that will define the proxy class
	 * @param interfaces
	 *            an array of {@code Class} objects, each one identifying an
	 *            interface that will be implemented by the returned proxy
	 *            object
	 * @param h
	 *            the invocation handler that handles the dispatched method
	 *            invocations
	 * @return a new proxy object that delegates to the handler {@code h}
	 * @throws IllegalArgumentException
	 *             if any of the interface restrictions are violated
	 * @throws NullPointerException
	 *             if the interfaces or any of its elements are null
	 */
	public static Object newProxyInstance(ClassLoader loader,
			Class<?>[] interfaces, InvocationHandler h)
			throws IllegalArgumentException {
		if (h == null) {
			throw new NullPointerException();
		}
		try {
			return getProxyClass(loader, interfaces).getConstructor(
					new Class<?>[] { InvocationHandler.class }).newInstance(
					new Object[] { h });
		} catch (NoSuchMethodException ex) {
			throw (InternalError) (new InternalError(ex.toString())
					.initCause(ex));
		} catch (IllegalAccessException ex) {
			throw (InternalError) (new InternalError(ex.toString())
					.initCause(ex));
		} catch (InstantiationException ex) {
			throw (InternalError) (new InternalError(ex.toString())
					.initCause(ex));
		} catch (InvocationTargetException ex) {
			Throwable target = ex.getTargetException();
			throw (InternalError) (new InternalError(target.toString())
					.initCause(target));
		}
	}

	/**
	 * Indicates whether or not the specified class is a dynamically generated
	 * proxy class.
	 * 
	 * @param cl
	 *            the class
	 * @return {@code true} if the class is a proxy class, {@code false}
	 *         otherwise
	 * @throws NullPointerException
	 *             if the class is {@code null}
	 */
	public static boolean isProxyClass(Class<?> cl) {
		if (cl == null) {
			throw new NullPointerException();
		}
		synchronized (proxyCache) {
			return proxyCache.containsKey(cl);
		}
	}

	/**
	 * Returns the invocation handler of the specified proxy instance.
	 * 
	 * @param proxy
	 *            the proxy instance
	 * @return the invocation handler of the specified proxy instance
	 * @throws IllegalArgumentException
	 *             if the supplied {@code proxy} is not a proxy object
	 */
	public static InvocationHandler getInvocationHandler(Object proxy)
			throws IllegalArgumentException {

		if (isProxyClass(proxy.getClass())) {
			return ((Proxy) proxy).h;
		}

		throw new IllegalArgumentException(Messages.getString("luni.54")); //$NON-NLS-1$
	}

	private static Class<?> defineClassImpl(ClassLoader classLoader,
			String className, byte[] classFileBytes) {
		return ClassLoaderHelper.defineClass(classLoader, className,
				classFileBytes, 0, classFileBytes.length);
	}

}
