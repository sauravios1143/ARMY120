findMinSort() {
  List<int> arr =[4 ,3, 1, 2];
  Map<int, bool> visitedMap = Map<int, bool>();
  int sum = 0;
  for (int i = 0; i < arr.length; i++) {
    if (visitedMap[i] != true) {
      int a = i;
      print("a--${a} ${arr[i]}");
      int b = arr[i]-1;
      int length = 1;
      visitedMap[i] = true;
      while (b != i) {
        print("b==> $b");
        visitedMap[b] = true;
        a = b;
        b = arr[b] - 1;
        length++;
      }
      sum += length - 1;
    }
    print("sort-->$sum");
    return sum;
  }
}
