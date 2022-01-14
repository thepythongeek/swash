int findRating(String score) {
  int rating = double.parse(score).toInt();
  if (rating >= 0 && rating <= 19) {
    return 0;
  } else if (rating >= 20 && rating <= 39) {
    return 1;
  } else if (rating >= 40 && rating <= 59) {
    return 2;
  } else if (rating >= 60 && rating <= 79) {
    return 3;
  } else {
    return 4;
  }
}
