class TopVoters {
  List<Voter> voters;

  TopVoters({required this.voters});

  factory TopVoters.fromJson(Map<String, dynamic> json) {
    List<Voter> voters = [];
    for (Map voter in json['voters']) {
      voters.add(Voter.fromjson(voter));
    }
    return TopVoters(voters: voters);
  }
}

class Voter {
  final String id;
  final String name;
  final String votes;

  Voter({required this.id, required this.name, required this.votes});

  factory Voter.fromjson(Map json) {
    return Voter(
        id: json['user_id'], name: json['name'], votes: json['votes_count']);
  }
}
