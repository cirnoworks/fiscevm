/* Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package java.lang;

@SuppressWarnings("unchecked")
public final class Void {

	public static final Class<Void> TYPE;
	static {
		Class<?> clz = null;
		try {
			clz = Class.forName("void");
		} catch (java.lang.ClassNotFoundException e) {
			try {
				clz = Class.forName("<void");
			} catch (java.lang.ClassNotFoundException ex) {
				ex.printStackTrace();
				throw new RuntimeException(ex);
			}
		}
		TYPE = (java.lang.Class<Void>) clz;
	}

	private Void() {
	}
}
