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

/**
 * @author Nikolay A. Kuznetsov
 */
package java.util.regex;

/**
 * Represents node accepting single character from the given char class. Note,
 * this class contains normalized characters fo unicode case, asci case is
 * supported through adding both symbols to the range.
 * 
 * @author Nikolay A. Kuznetsov
 */
class UCIRangeSet extends LeafSet {
    
    private AbstractCharClass chars;

    private boolean alt = false;

    public UCIRangeSet(AbstractCharClass cs, AbstractSet next) {
        super(next);
        this.chars = cs.getInstance();
        this.alt = cs.alt;
    }

    public UCIRangeSet(AbstractCharClass cc) {
        this.chars = cc.getInstance();
        this.alt = cc.alt;
    }
  
    public int accepts(int strIndex, CharSequence testString) {
        return (chars.contains(Character.toLowerCase(Character
                .toUpperCase(testString.charAt(strIndex))))) ? 1 : -1;
    }

    protected String getName() {
        return "UCI range:" + (alt ? "^ " : " ") + chars.toString(); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    }
}