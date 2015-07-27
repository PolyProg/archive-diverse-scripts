import java.io.*;
import java.util.*;
public class Sample {
  public static void main(String args[]) throws Exception {
    BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
    int num_testcases = Integer.parseInt(in.readLine());
    for(int i=0;i<num_testcases;++i) {
      StringTokenizer st = new StringTokenizer(in.readLine());
      int a = Integer.parseInt(st.nextToken());
      int b = Integer.parseInt(st.nextToken());
      System.out.println((a+b)+" "+(a-b));
    }
  }
}
