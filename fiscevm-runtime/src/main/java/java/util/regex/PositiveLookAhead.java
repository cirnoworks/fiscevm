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

import java.util.ArrayList;

/**
 * Positive lookahead node.
 * 
 * @author Nikolay A. Kuznetsov
 */
class PositiveLookAhead extends AtomicJointSet {
    
    public PositiveLookAhead(ArrayList children, FSet fSet) {
        super(children, fSet);
    }

    /**
     * Returns stringIndex+shift, the next position to match
     */
    public int matches(int stringIndex, CharSequence testString,
            MatchResultImpl matchResult) {
        int size = children.size();
        for (int i = 0; i < size; i++) {
            AbstractSet e = (AbstractSet) children.get(i);
            int shift = e.matches(stringIndex, testString, matchResult);
            if (shift >= 0) {
                // PosLookaheadFset always returns true, position remains the
                // same
                // next.match() from;
                return next.matches(stringIndex, testString, matchResult);
            }
        }

        return -1;
    }

    public boolean hasConsumed(MatchResultImpl matchResult) {
        return false;
    }

    protected String getName() {
        return "PosLookaheadJointSet"; //$NON-NLS-1$
    }
}
