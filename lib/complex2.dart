import 'dart:math';

class Complex2 {
  double real;
  double imag;

  Complex2(this.real, this.imag);

  Complex2 clone() {
    return Complex2(real, imag);
  }

  // Создание из полярных координат
  static Complex2 fromPolar(double r, double phi) {
    return Complex2(r * cos(phi), r * sin(phi));
  }

  static Complex2 zero() {
    return Complex2(0, 0);
  }

  Complex2 add(Complex2 x) {
    real += x.real;
    imag += x.imag;
    return this;
  }

  Complex2 sub(Complex2 x) {
    real -= x.real;
    imag -= x.imag;
    return this;
  }

  Complex2 mulScalar(double x) {
    real *= x;
    imag *= x;
    return this;
  }

  Complex2 divScalar(double x) {
    real /= x;
    imag /= x;
    return this;
  }

  double abs() {
    return sqrt(real * real + imag * imag);
  }
}
