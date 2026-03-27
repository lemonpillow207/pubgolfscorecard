class Question {
  final String question;
  final String answer;
  final String powerup;
  final bool isPowerDown;

  const Question({
    required this.question,
    required this.answer,
    required this.powerup,
    this.isPowerDown = false,
  });
}

const List<Question> kQuestions = [
  Question(
    question: 'Hoeveel video\'s heeft Adventure with Boyke (Soerendra) totaal geupload?',
    answer: '786',
    powerup: 'Het team dat het goed heeft mag de slokken verdubbelen van een ander team bij een pub naar keuze. Deze mag in de volgende 5 pubs ingezet worden.',
  ),
  Question(
    question: 'Hoeveel blikken monster zijn er verkocht in 2025 uit de koelkast van Joey?',
    answer: '94',
    powerup: 'Team dat het verste van het antwoord af zit, krijgt deze ronde dubbele slagen.',
    isPowerDown: true,
  ),
  Question(
    question: 'Hoeveel KM afstand is het vanaf Korton naar Kristianstad in Zweden?',
    answer: '938 KM',
    powerup: 'Het team wat het dichtstbij zit kan een drankje verdubbelen voor een ander team. Dus 1 baco worden 2 baco\'s.',
  ),
  Question(
    question: 'Hoeveel inwoners heeft Barsingerhorn, het kut dorp van Jelle?',
    answer: '905',
    powerup: 'De oudste persoon van het team moet zijn drankje met een ijsblokje in zijn mond opdrinken.',
    isPowerDown: true,
  ),
  Question(
    question: 'Wat voor merk t-shirt had Marvin de eerste dag aan op kantoor?',
    answer: 'Cisco',
    powerup: 'Elk team dat het fout heeft moet zijn drankje deze ronde drinken met een knijper op zijn neus.',
    isPowerDown: true,
  ),
  Question(
    question: 'Hoeveel likes heeft de meest gelikete post op het Instagram kanaal elbarriocubano?',
    answer: '107 likes',
    powerup: 'Het team dat het dichtste bij zit moet een kroketje eten bij de eerst volgende snackbar/Febo.',
  ),
  Question(
    question: 'Wie is dit als je de letters op de correcte plek neerzet binnen Korton? SennakleNeosninsNjesli',
    answer: 'Annelies Nijssen-Snoek',
    powerup: 'Wissel de scores met iemand van een ander team naar keuze.',
  ),
  Question(
    question: 'Hoeveel tickets heeft Jennifer totaal afgesloten in het jaar 2025?',
    answer: '212',
    powerup: 'Het team wat het dichtstbij zit mag zijn drankje bij de volgende hole aan een ander team uitdelen.',
    isPowerDown: true,
  ),
  Question(
    question: 'Hoeveel verschillende kleuren Doppers heeft Fabian thuis staan?',
    answer: '9',
    powerup: 'De volgende hole mag je een drankje naar keuze nemen.',
  ),
];
