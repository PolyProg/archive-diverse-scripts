object Sample {
  def main(args: Array[String]): Unit = {
    val in = new java.io.BufferedReader(
             new java.io.InputStreamReader(System.in));
    val num_testcases = Integer.parseInt(in.readLine());
    for(i <- 1 to num_testcases) {
      val st = new java.util.StringTokenizer(in.readLine());
      val a = Integer.parseInt(st.nextToken());
      val b = Integer.parseInt(st.nextToken());
      println((a+b)+" "+(a-b));
    }
  }
}
