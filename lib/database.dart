class DatabaseServices {
  Future<Map<String, List<String>>> getQuestions() async {
    // return Map<String, List<String>> floors = {
    await Future.delayed(
      Duration(
        seconds: 2,
      ),
    );
    return {
      "": ["0", "1", null, "3"],
      "0": [null, "01", "Back", null],
      "1": [null, null, null, "Back"],
      "3": [null, "Back", "32", null],
      "01": [null, null, null, "Back"],
      "32": ["Back", null, null, null],
    };
  }
}
