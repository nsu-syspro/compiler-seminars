int avg(int a, int b) {
  int c = (a + b);
  a = (a + b);
  return a / 2;
}

float avg3(int a, int b) {
  return (float)(a + b) / 2;
}

int main() {
  return avg(4, 6);
}
