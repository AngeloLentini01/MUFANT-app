import 'package:app/model/generic/base_entity_model.dart';
import 'package:meta/meta.dart';

/// Abstract base class for table managers in the database.
/// Table managers handle CRUD operations for specific entity types.
///
/// @param T The entity type this manager handles, must extend BaseEntityModel
abstract class TableManager<T extends BaseEntityModel> {
  /// The name of the database table this manager operates on
  final String tableName;

  /// Creates a new table manager for the specified table
  TableManager(this.tableName);

  /// Creates a new entity in the database
  @mustCallSuper
  Future<T> create(T entity) async {
    // Logic to insert entity into database
    // This is a template and should be implemented by subclasses
    throw UnimplementedError('create method must be implemented by subclasses');
  }

  /// Retrieves an entity by its ID
  @mustCallSuper
  Future<T?> read(String id) async {
    // Logic to query entity from database
    // This is a template and should be implemented by subclasses
    throw UnimplementedError('read method must be implemented by subclasses');
  }

  /// Updates an existing entity in the database
  @mustCallSuper
  Future<T> update(T entity) async {
    // Logic to update entity in database
    // This is a template and should be implemented by subclasses
    throw UnimplementedError('update method must be implemented by subclasses');
  }

  /// Deletes an entity from the database
  @mustCallSuper
  Future<bool> delete(String id) async {
    // Logic to delete entity from database
    // This is a template and should be implemented by subclasses
    throw UnimplementedError('delete method must be implemented by subclasses');
  }

  /// Lists all entities from the table
  @mustCallSuper
  Future<List<T>> list() async {
    // Logic to list all entities from database
    // This is a template and should be implemented by subclasses
    throw UnimplementedError('list method must be implemented by subclasses');
  }

  /// Maps a database row to an entity object
  @protected
  T mapToEntity(Map<String, dynamic> row);

  /// Maps an entity object to a database row
  @protected
  Map<String, dynamic> mapToRow(T entity);
}
