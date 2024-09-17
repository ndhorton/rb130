function p(str, regex) {
    console.log(str.match(regex));
  }
  
  let text = "cat\ncot\nCATASTROPHE\nWILDCAUGHT\n" +
             "wildcat\n-GET-\nYacht"
  
  p(text, /^c.t/mig) // [ 'cat', 'cot', 'CAT' ]
  p(text, /c.t$/mig) // [ 'cat', 'cot', 'cat', 'cht' ]