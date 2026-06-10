/// Hand-authored mock catalog, led by the BIAN payment service domains. Shaped
/// like the JSON the live Drupal endpoint will return, so the swap to a live
/// data source needs no UI/Bloc changes.
const String catalogJson = r'''
[
  {
    "id": "payment-initiation-v1",
    "name": "Payment Initiation API",
    "tagline": "Capture customer payment instructions (BIAN Payment Initiation).",
    "description": "The BIAN Payment Initiation service domain. Capture a customer's payment instruction, validate it, and track its lifecycle through a control record. The first step of every transfer — internal or external.",
    "category": "Payments",
    "version": "v1.0",
    "colorIndex": 0,
    "visibility": "public",
    "featured": true,
    "basePath": "/payment-initiation/v1",
    "tierName": "Standard",
    "quotaLimit": 200000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "POST", "path": "/payment-initiation/initiate", "summary": "Initiate a payment initiation"},
      {"method": "GET", "path": "/payment-initiation/{id}/retrieve", "summary": "Retrieve a payment initiation"},
      {"method": "PUT", "path": "/payment-initiation/{id}/update", "summary": "Update a payment initiation"},
      {"method": "PUT", "path": "/payment-initiation/{id}/control", "summary": "Control (suspend / resume / cancel)"}
    ],
    "sampleResponse": "{\n  \"paymentInitiationInstanceReference\": \"PI-7c9a12\",\n  \"paymentInitiationStatus\": \"initiated\",\n  \"paymentInstruction\": {\n    \"debitAccount\": \"GB29NWBK60161331926819\",\n    \"creditAccount\": \"GB29NWBK60161300000001\",\n    \"amount\": { \"value\": \"250.00\", \"currency\": \"GBP\" },\n    \"paymentType\": \"internal\"\n  },\n  \"dateTime\": \"2026-06-10T09:14:22Z\"\n}",
    "docsMarkdown": "## BIAN Payment Initiation\nThis service domain captures and governs a customer payment instruction.\n\n### Behaviour qualifiers\n- `Initiate` — create a new payment initiation control record\n- `Update` — amend instruction details before order creation\n- `Retrieve` — read current status\n- `Control` — suspend, resume or cancel\n\n### Control record\nEach initiation returns a `paymentInitiationInstanceReference` you carry forward into the Payment Order service domain.\n\n### Next\nFeed the reference into `POST /payment-order/initiate`. See the **Flows** section for the full internal and external transfer journeys."
  },
  {
    "id": "payment-order-v1",
    "name": "Payment Order API",
    "tagline": "Validate, route and schedule payment orders (BIAN Payment Order).",
    "description": "The BIAN Payment Order service domain. Turn an initiated payment into a validated, routed order — selecting the clearing scheme (book transfer for internal, Faster Payments / SEPA / SWIFT for external) and running limit and sanctions checks.",
    "category": "Payments",
    "version": "v1.0",
    "colorIndex": 5,
    "visibility": "public",
    "featured": true,
    "basePath": "/payment-order/v1",
    "tierName": "Standard",
    "quotaLimit": 200000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "POST", "path": "/payment-order/initiate", "summary": "Create a payment order"},
      {"method": "GET", "path": "/payment-order/{id}/retrieve", "summary": "Retrieve a payment order"},
      {"method": "PUT", "path": "/payment-order/{id}/update", "summary": "Update a payment order"}
    ],
    "sampleResponse": "{\n  \"paymentOrderInstanceReference\": \"PO-3f88b1\",\n  \"paymentOrderStatus\": \"validated\",\n  \"routingScheme\": \"BookTransfer\",\n  \"linkedPaymentInitiation\": \"PI-7c9a12\",\n  \"amount\": { \"value\": \"250.00\", \"currency\": \"GBP\" }\n}",
    "docsMarkdown": "## BIAN Payment Order\nManages the payment order lifecycle: validation, routing-scheme selection, and scheduling.\n\n### Routing schemes\n- `BookTransfer` — both accounts at this bank (internal)\n- `FasterPayments` / `SEPA` / `SWIFT` — beneficiary at another bank (external)\n\n### Link\nProvide `linkedPaymentInitiation` so the order traces back to the customer instruction. The returned `paymentOrderInstanceReference` is consumed by Payment Execution."
  },
  {
    "id": "payment-execution-v1",
    "name": "Payment Execution API",
    "tagline": "Execute and settle payment orders (BIAN Payment Execution).",
    "description": "The BIAN Payment Execution service domain. Execute a validated payment order and track settlement. Internal transfers settle instantly via ledger book transfer; external transfers settle through the selected clearing rail.",
    "category": "Payments",
    "version": "v1.0",
    "colorIndex": 3,
    "visibility": "public",
    "featured": true,
    "basePath": "/payment-execution/v1",
    "tierName": "Standard",
    "quotaLimit": 200000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "POST", "path": "/payment-execution/execute", "summary": "Execute a payment"},
      {"method": "GET", "path": "/payment-execution/{id}/retrieve", "summary": "Retrieve execution & settlement status"}
    ],
    "sampleResponse": "{\n  \"paymentExecutionInstanceReference\": \"PE-91aa02\",\n  \"paymentExecutionStatus\": \"executed\",\n  \"settlementStatus\": \"settled\",\n  \"linkedPaymentOrder\": \"PO-3f88b1\",\n  \"valueDate\": \"2026-06-10\",\n  \"amount\": { \"value\": \"250.00\", \"currency\": \"GBP\" }\n}",
    "docsMarkdown": "## BIAN Payment Execution\nExecutes a validated payment order and reports settlement.\n\n### Status model\n- `paymentExecutionStatus`: `executing` → `executed`\n- `settlementStatus`: `pending_clearing` → `settled`\n\n### Internal vs external\nInternal (book transfer) settles synchronously. External submits to the clearing rail and you poll `GET /payment-execution/{id}/retrieve` for a `clearingReference` and `settled` status. See **Flows**."
  },
  {
    "id": "accounts-v2",
    "name": "Accounts API",
    "tagline": "Read account information, balances and transactions with consent.",
    "description": "Access consented account data: balances, transactions, standing orders and direct debits. Used to resolve debit/credit accounts before initiating a payment.",
    "category": "Banking",
    "version": "v2.1",
    "colorIndex": 1,
    "visibility": "public",
    "featured": false,
    "basePath": "/accounts/v2",
    "tierName": "Standard",
    "quotaLimit": 250000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "GET", "path": "/accounts", "summary": "List consented accounts"},
      {"method": "GET", "path": "/accounts/{id}/balances", "summary": "Get balances"},
      {"method": "GET", "path": "/accounts/{id}/transactions", "summary": "List transactions"}
    ],
    "sampleResponse": "{\n  \"accounts\": [\n    { \"id\": \"acc_1182\", \"iban\": \"GB29NWBK60161331926819\", \"currency\": \"GBP\", \"nickname\": \"Everyday\" }\n  ]\n}",
    "docsMarkdown": "## Overview\nThe Accounts API exposes consented account information.\n\n### Consent\nData access is gated by an active consent grant. Calls without a valid consent return `403 consent_required`."
  },
  {
    "id": "fx-rates-v1",
    "name": "FX Rates API",
    "tagline": "Real-time and historical foreign-exchange rates.",
    "description": "Stream live FX rates and convert amounts across 150+ currencies — used to price cross-currency external transfers.",
    "category": "Markets",
    "version": "v1.2",
    "colorIndex": 4,
    "visibility": "public",
    "featured": false,
    "basePath": "/fx/v1",
    "tierName": "Standard",
    "quotaLimit": 1000000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "GET", "path": "/rates", "summary": "Get latest rates"},
      {"method": "GET", "path": "/convert", "summary": "Convert an amount"}
    ],
    "sampleResponse": "{\n  \"base\": \"GBP\",\n  \"rates\": { \"USD\": 1.27, \"EUR\": 1.17 }\n}",
    "docsMarkdown": "## Overview\nThe FX Rates API provides live and historical exchange rates.\n\n### Freshness\nLive rates are refreshed every 5 seconds during market hours."
  },
  {
    "id": "identity-v1",
    "name": "Identity API",
    "tagline": "Verify customers and manage OIDC-backed identities.",
    "description": "Verify identity documents, run KYC checks, and manage user profiles federated from your identity provider.",
    "category": "Identity",
    "version": "v1.0",
    "colorIndex": 2,
    "visibility": "partner",
    "featured": false,
    "basePath": "/identity/v1",
    "tierName": "Partner",
    "quotaLimit": 50000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "POST", "path": "/verifications", "summary": "Start an identity verification"},
      {"method": "GET", "path": "/verifications/{id}", "summary": "Get verification result"}
    ],
    "sampleResponse": "{\n  \"id\": \"vrf_55ab\",\n  \"status\": \"VERIFIED\",\n  \"level\": \"high\"\n}",
    "docsMarkdown": "## Overview\nThe Identity API runs verification and KYC workflows.\n\n### Access\nThis is a **partner** product — registering an app against it requires approval from the API team."
  },
  {
    "id": "cards-v1",
    "name": "Cards API",
    "tagline": "Issue virtual cards and manage controls in real time.",
    "description": "Programmatically issue virtual and physical cards, set spend controls, and stream authorisation events.",
    "category": "Payments",
    "version": "v1.1",
    "colorIndex": 5,
    "visibility": "partner",
    "featured": false,
    "basePath": "/cards/v1",
    "tierName": "Partner",
    "quotaLimit": 75000,
    "quotaInterval": "month",
    "endpoints": [
      {"method": "POST", "path": "/cards", "summary": "Issue a card"},
      {"method": "PATCH", "path": "/cards/{id}/controls", "summary": "Update spend controls"},
      {"method": "GET", "path": "/cards/{id}", "summary": "Get card details"}
    ],
    "sampleResponse": "{\n  \"id\": \"card_3310\",\n  \"last4\": \"4242\",\n  \"state\": \"ACTIVE\"\n}",
    "docsMarkdown": "## Overview\nThe Cards API issues and controls payment cards.\n\n### Access\nThis is a **partner** product — app registration requires approval."
  }
]
''';
