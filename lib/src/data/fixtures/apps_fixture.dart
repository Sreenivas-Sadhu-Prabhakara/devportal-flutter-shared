/// Seed apps for the demo developer. The mock apps repository starts from this
/// and lets the user register more in-session.
const String appsJson = r'''
[
  {
    "id": "app_aurora",
    "name": "Aurora Mobile",
    "developerEmail": "dev@example.com",
    "status": "approved",
    "description": "Consumer banking mobile app.",
    "productIds": ["accounts-v2", "payments-v1"],
    "createdAt": "2026-04-18",
    "colorIndex": 1,
    "credentials": [
      {
        "key": "qC8kR2mNzVfP7tLxWd0aYb3HsJ4uE6oG",
        "secret": "s_4Td9Hu2KpQ7mZx1Rb8Nv",
        "status": "approved",
        "productIds": ["accounts-v2", "payments-v1"],
        "expiresAt": null
      }
    ]
  },
  {
    "id": "app_ledgerbot",
    "name": "LedgerBot",
    "developerEmail": "dev@example.com",
    "status": "approved",
    "description": "Automated reconciliation service.",
    "productIds": ["payments-v1", "fx-rates-v1"],
    "createdAt": "2026-05-29",
    "colorIndex": 0,
    "credentials": [
      {
        "key": "Hb7nP1xR9kTm4Wj2Lq6Yc0Zs5Vd8Ng3",
        "secret": "s_9Lm2Qr6Tz4Xb1Pw7Kd",
        "status": "approved",
        "productIds": ["payments-v1", "fx-rates-v1"],
        "expiresAt": null
      }
    ]
  }
]
''';
