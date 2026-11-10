
import 'dart:io';

mixin Timestamp {
  DateTime dateCreated = DateTime.now();

  String getDate() {
    return dateCreated.toString();
  }
}

abstract class CenterRecord {
  String id;

  CenterRecord(this.id);

  String getDetails();
}

class LearningResource extends CenterRecord with Timestamp {
  String _title;
  int _quantity;

  LearningResource(String id, String title, int quantity)
      : _title = title,
        _quantity = quantity,
        super(id);

  String get title => _title;
  int get quantity => _quantity;

  bool borrowResource() {
    if (_quantity > 0) {
      _quantity--;
      return true;
    }
    return false;
  }

  @override
  String getDetails() {
    return 'Resource ID: $id\n'
        'Title: $_title\n'
        'Available Quantity: $_quantity';
  }
}

class Participant extends CenterRecord with Timestamp {
  String _name;
  String _contact;

  List<String> borrowedResources = [];

  Participant(String id, String name, String contact)
      : _name = name,
        _contact = contact,
        super(id);

  String get name => _name;

  void borrowBook(String resourceId) {
    borrowedResources.add(resourceId);
  }

  @override
  String getDetails() {
    return 'Participant ID: $id\n'
        'Name: $_name\n'
        'Contact: $_contact\n'
        'Borrowed Resources: ${borrowedResources.length}';
  }
}

List<LearningResource> resources = [];
List<Participant> participants = [];

Map<String, CenterRecord> records = {};

int resourceNumber = 1;
int participantNumber = 1;

String getInput(String message) {
  while (true) {
    stdout.write(message);
    String? input = stdin.readLineSync();

    if (input == null) {
      print('No input received. Closing program.');
      exit(0);
    }

    if (input.trim().isNotEmpty) {
      return input.trim();
    }

    print('Input cannot be empty. Try again.');
  }
}

int getNumber(String message) {
  while (true) {
    String input = getInput(message);

    try {
      int number = int.parse(input);

      if (number > 0) {
        return number;
      } else {
        print('Please enter a number greater than zero.');
      }
    } catch (e) {
      print('Invalid number. Please enter a whole number.');
    }
  }
}

void addResource() {
  print('\n--- ADD LEARNING RESOURCE ---');

  String title = getInput('Enter resource title: ');
  int quantity = getNumber('Enter quantity: ');

  String id = 'R${resourceNumber++}';

  LearningResource resource =
      LearningResource(id, title, quantity);

  resources.add(resource);
  records[id] = resource;

  print('\nResource added successfully!');
  print(resource.getDetails());
}

void registerParticipant() {
  print('\n--- REGISTER PARTICIPANT ---');

  String name = getInput('Enter participant name: ');
  String contact = getInput('Enter contact number: ');

  String id = 'P${participantNumber++}';

  Participant participant =
      Participant(id, name, contact);

  participants.add(participant);
  records[id] = participant;

  print('\nParticipant registered successfully!');
  print(participant.getDetails());
}

void borrowResource() {
  print('\n--- BORROW LEARNING RESOURCE ---');

  if (resources.isEmpty || participants.isEmpty) {
    print('Please add a resource and register a participant first.');
    return;
  }

  String participantId =
      getInput('Enter participant ID (Example: P1): ');

  String resourceId =
      getInput('Enter resource ID (Example: R1): ');

  if (!records.containsKey(participantId) ||
      records[participantId] is! Participant) {
    print('Participant not found.');
    return;
  }

  if (!records.containsKey(resourceId) ||
      records[resourceId] is! LearningResource) {
    print('Resource not found.');
    return;
  }

  Participant participant =
      records[participantId] as Participant;

  LearningResource resource =
      records[resourceId] as LearningResource;

  if (resource.borrowResource()) {
    participant.borrowBook(resourceId);

    print('\nBorrowing successful!');
    print('${participant.name} borrowed ${resource.title}.');
    print('Remaining quantity: ${resource.quantity}');
  } else {
    print('Sorry, this resource is not available.');
  }
}

void viewRecords() {
  print('\n--- ALL CENTER RECORDS ---');

  if (records.isEmpty) {
    print('No records available.');
    return;
  }

  for (CenterRecord record in records.values) {
    print('\n${record.getDetails()}');

    if (record is LearningResource) {
      print('Date Created: ${record.getDate()}');
    } else if (record is Participant) {
      print('Date Created: ${record.getDate()}');
    }

    print('-------------------------');
  }

  print('\nTotal Resources: ${resources.length}');
  print('Total Participants: ${participants.length}');
}

void main() {
  bool running = true;

  print('========================================');
  print('   COMMUNITY LEARNING CENTER SYSTEM');
  print('========================================');

  while (running) {
    print('\nMAIN MENU');
    print('1. Add Learning Resource');
    print('2. Register Participant');
    print('3. Borrow Learning Resource');
    print('4. View All Records');
    print('5. Exit');

    String choice = getInput('\nEnter your choice: ');

    switch (choice) {
      case '1':
        addResource();
        break;

      case '2':
        registerParticipant();
        break;

      case '3':
        borrowResource();
        break;

      case '4':
        viewRecords();
        break;

      case '5':
        running = false;
        print('\nThank you for using the system!');
        break;

      default:
        print('\nInvalid choice. Please select 1 to 5.');
    }
  }
}
