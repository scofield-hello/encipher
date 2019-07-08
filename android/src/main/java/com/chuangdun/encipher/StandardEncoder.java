package com.chuangdun.encipher;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author Nickey
 */
public class StandardEncoder {

  public static String encode(String rawPass, String salt)
      throws NoSuchAlgorithmException, UnsupportedEncodingException {
    String saltedPass = mergePasswordAndSalt(rawPass, salt, false);
    MessageDigest messageDigest = MessageDigest.getInstance("MD5");
    byte[] digest = messageDigest.digest(saltedPass.getBytes("UTF-8"));
    return getString(digest);
  }

  private static String getString(byte[] b) {
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < b.length; i++) {
      if (Integer.toHexString(0xff & b[i]).length() == 1) {
        buffer.append("0").append(Integer.toHexString(0xff & b[i]));
      } else {
        buffer.append(Integer.toHexString(0xff & b[i]));
      }
    }
    return buffer.toString();
  }

  public static String mergePasswordAndSalt(String password, Object salt,
      boolean strict) {
    if (password == null) {
      password = "";
    }
    if (strict && (salt != null)) {
      if ((salt.toString().lastIndexOf("{") != -1)
          || (salt.toString().lastIndexOf("}") != -1)) {
        throw new IllegalArgumentException(
            "Cannot use { or } in salt.toString()");
      }
    }
    if ((salt == null) || "".equals(salt)) {
      return password;
    } else {
      return password + "{" + salt.toString() + "}";
    }
  }

  public static String encrypt(String raw, String salt, int times) {
    String temp = raw;
    try {
      for (int i = 0; i < times; i++) {
        temp = encode(temp, salt);
      }
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    }
    return temp;
  }

}
