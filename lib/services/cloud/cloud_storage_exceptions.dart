
class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateNote extends CloudStorageException {}

//R in CRUD
class CouldNotGetAllNotes extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateNote extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteNote extends CloudStorageException {}
