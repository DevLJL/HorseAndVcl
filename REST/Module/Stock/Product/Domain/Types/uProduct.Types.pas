unit uProduct.Types;

interface

{$SCOPEDENUMS ON}
type
  TProductType = (Product, Service);
  TProductGenre = (None, Masculine, Feminine, Unisex);
  TProductCheckValueBeforeInsert = (No, Yes, Quiz);
  TProductMovStock = (Increment, Decrement);

implementation

end.

