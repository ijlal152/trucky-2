/// Transaction payment types used for filtering.
enum PaymentType { all, sale, payment, returnn, refund, purchase }

/// List sorting type.
enum SortType {
  none,
  ascending,
  descending,
  highToLow,
  lowToHigh,
  newestFirst,
  oldestFirst
}

/// Where the user navigated from (client/supplier vs sale/purchase).
enum UserNavigation {
  fromClientSupp,
  fromSalePurchase,
}

/// Whether an entity is being added or edited.
enum OperationType {
  add,
  edit,
}

/// Transaction type to differentiate between Sale/Purchase and Return.
enum TransactionType {
  sale,
  returnTransaction,
}

/// Enum to differentiate between Client and Supplier.
enum EntityType { client, supplier, none }
