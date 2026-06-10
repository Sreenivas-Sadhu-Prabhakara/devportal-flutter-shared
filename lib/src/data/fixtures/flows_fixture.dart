/// End-to-end fund-transfer flows chaining BIAN Payment Initiation → Order →
/// Execution. The external flow adds a clearing/settlement confirmation step.
const String flowsJson = r'''
[
  {
    "id": "internal-transfer",
    "name": "Internal fund transfer",
    "summary": "Move funds between two accounts held at this bank. Settles instantly via ledger book transfer — no external clearing rail.",
    "kind": "internal",
    "colorIndex": 2,
    "steps": [
      {
        "title": "Initiate payment",
        "apiName": "Payment Initiation API",
        "method": "POST",
        "path": "/payment-initiation/initiate",
        "request": "{\n  \"paymentInstruction\": {\n    \"debitAccount\": \"GB29NWBK60161331926819\",\n    \"creditAccount\": \"GB29NWBK60161300000001\",\n    \"amount\": { \"value\": \"250.00\", \"currency\": \"GBP\" },\n    \"paymentType\": \"internal\",\n    \"remittanceInfo\": \"Move to savings\"\n  }\n}",
        "response": "{\n  \"paymentInitiationInstanceReference\": \"PI-7c9a12\",\n  \"paymentInitiationStatus\": \"initiated\"\n}",
        "note": "Customer instruction captured. Both accounts are held at this bank, so this will route as a book transfer."
      },
      {
        "title": "Create payment order",
        "apiName": "Payment Order API",
        "method": "POST",
        "path": "/payment-order/initiate",
        "request": "{\n  \"linkedPaymentInitiation\": \"PI-7c9a12\",\n  \"routingScheme\": \"BookTransfer\",\n  \"amount\": { \"value\": \"250.00\", \"currency\": \"GBP\" }\n}",
        "response": "{\n  \"paymentOrderInstanceReference\": \"PO-3f88b1\",\n  \"paymentOrderStatus\": \"validated\",\n  \"routingScheme\": \"BookTransfer\"\n}",
        "note": "Limit checks pass. Order validated and routed as an internal book transfer — no external rail involved."
      },
      {
        "title": "Execute & settle",
        "apiName": "Payment Execution API",
        "method": "POST",
        "path": "/payment-execution/execute",
        "request": "{\n  \"linkedPaymentOrder\": \"PO-3f88b1\"\n}",
        "response": "{\n  \"paymentExecutionInstanceReference\": \"PE-91aa02\",\n  \"paymentExecutionStatus\": \"executed\",\n  \"settlementStatus\": \"settled\",\n  \"valueDate\": \"2026-06-10\"\n}",
        "note": "Internal transfer settles instantly via a ledger book transfer. Funds are available immediately."
      }
    ]
  },
  {
    "id": "external-transfer",
    "name": "External fund transfer",
    "summary": "Send funds to a beneficiary at another bank. Routed via Faster Payments and confirmed once the clearing rail settles.",
    "kind": "external",
    "colorIndex": 0,
    "steps": [
      {
        "title": "Initiate payment",
        "apiName": "Payment Initiation API",
        "method": "POST",
        "path": "/payment-initiation/initiate",
        "request": "{\n  \"paymentInstruction\": {\n    \"debitAccount\": \"GB29NWBK60161331926819\",\n    \"creditAccount\": \"GB94BARC10201530093459\",\n    \"creditorBank\": { \"bic\": \"BARCGB22\" },\n    \"amount\": { \"value\": \"1200.00\", \"currency\": \"GBP\" },\n    \"paymentType\": \"external\",\n    \"remittanceInfo\": \"Invoice 4471\"\n  }\n}",
        "response": "{\n  \"paymentInitiationInstanceReference\": \"PI-aa31f0\",\n  \"paymentInitiationStatus\": \"initiated\"\n}",
        "note": "Beneficiary is at another bank (BIC BARCGB22), so this will route over an external clearing scheme."
      },
      {
        "title": "Create payment order",
        "apiName": "Payment Order API",
        "method": "POST",
        "path": "/payment-order/initiate",
        "request": "{\n  \"linkedPaymentInitiation\": \"PI-aa31f0\",\n  \"routingScheme\": \"FasterPayments\",\n  \"amount\": { \"value\": \"1200.00\", \"currency\": \"GBP\" }\n}",
        "response": "{\n  \"paymentOrderInstanceReference\": \"PO-7d2c55\",\n  \"paymentOrderStatus\": \"validated\",\n  \"routingScheme\": \"FasterPayments\"\n}",
        "note": "Sanctions and limit checks pass. Order routed to the Faster Payments scheme."
      },
      {
        "title": "Execute payment",
        "apiName": "Payment Execution API",
        "method": "POST",
        "path": "/payment-execution/execute",
        "request": "{\n  \"linkedPaymentOrder\": \"PO-7d2c55\"\n}",
        "response": "{\n  \"paymentExecutionInstanceReference\": \"PE-55b9c1\",\n  \"paymentExecutionStatus\": \"executing\",\n  \"settlementStatus\": \"pending_clearing\"\n}",
        "note": "Submitted to the external clearing rail. Unlike an internal transfer, settlement is not yet final."
      },
      {
        "title": "Confirm settlement",
        "apiName": "Payment Execution API",
        "method": "GET",
        "path": "/payment-execution/PE-55b9c1/retrieve",
        "request": "",
        "response": "{\n  \"paymentExecutionInstanceReference\": \"PE-55b9c1\",\n  \"paymentExecutionStatus\": \"executed\",\n  \"settlementStatus\": \"settled\",\n  \"clearingReference\": \"FPS-20260610-99812\",\n  \"valueDate\": \"2026-06-10\"\n}",
        "note": "Poll execution until the clearing rail confirms settlement at the beneficiary bank."
      }
    ]
  }
]
''';
