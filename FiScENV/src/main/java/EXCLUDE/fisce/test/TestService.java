package EXCLUDE.fisce.test;

import com.cirnoworks.fisce.privat.FiScEVM;

public class TestService {
	public static boolean nativeFail = true;

	public static native void fail(String message);

	public static void assertTrue(boolean value) {
		assertTrue(value, " no message.");
	}

	public static void assertTrue(boolean value, String failMessage) {
		if (!value) {
			try {
				throw new AssertionError();
			} catch (AssertionError e) {
				e.printStackTrace(FiScEVM.debug);
			}
			if (nativeFail) {
				fail("Assertion error: " + failMessage);
			} else {
				System.err.println("Assertion error: " + failMessage);
			}
		}
	}
}
