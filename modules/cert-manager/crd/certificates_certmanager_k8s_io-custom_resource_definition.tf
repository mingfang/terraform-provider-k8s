resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "certificates_certmanager_k8s_io" {
  metadata {
    labels = {
      "controller-tools.k8s.io" = "1.0"
    }
    name = "certificates.certmanager.k8s.io"
  }
  spec {

    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].status
        EOF
      name = "Ready"
      type = "string"
    }
    additional_printer_columns {
      json_path = ".spec.secretName"
      name = "Secret"
      type = "string"
    }
    additional_printer_columns {
      json_path = ".spec.issuerRef.name"
      name = "Issuer"
      priority = 1
      type = "string"
    }
    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].message
        EOF
      name     = "Status"
      priority = 1
      type     = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
      name        = "Age"
      type        = "date"
    }
    group = "certmanager.k8s.io"
    names {
      kind   = "Certificate"
      plural = "certificates"
      short_names = [
        "cert",
        "certs",
      ]
    }
    scope = "Namespaced"
    validation {
      open_apiv3_schema = <<-JSON
        {
          "type": "object",
          "properties": {
            "apiVersion": {
              "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources",
              "type": "string"
            },
            "kind": {
              "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "properties": {
                "acme": {
                  "description": "ACME contains configuration specific to ACME Certificates. Notably, this contains details on how the domain names listed on this Certificate resource should be 'solved', i.e. mapping HTTP01 and DNS01 providers to DNS names.",
                  "properties": {
                    "config": {
                      "items": {
                        "properties": {
                          "domains": {
                            "description": "Domains is the list of domains that this SolverConfig applies to.",
                            "items": {
                              "type": "string"
                            },
                            "type": "array"
                          }
                        },
                        "required": [
                          "domains"
                        ],
                        "type": "object"
                      },
                      "type": "array"
                    }
                  },
                  "required": [
                    "config"
                  ],
                  "type": "object"
                },
                "commonName": {
                  "description": "CommonName is a common name to be used on the Certificate. If no CommonName is given, then the first entry in DNSNames is used as the CommonName. The CommonName should have a length of 64 characters or fewer to avoid generating invalid CSRs; in order to have longer domain names, set the CommonName (or first DNSNames entry) to have 64 characters or fewer, and then add the longer domain name to DNSNames.",
                  "type": "string"
                },
                "dnsNames": {
                  "description": "DNSNames is a list of subject alt names to be used on the Certificate. If no CommonName is given, then the first entry in DNSNames is used as the CommonName and must have a length of 64 characters or fewer.",
                  "items": {
                    "type": "string"
                  },
                  "type": "array"
                },
                "duration": {
                  "description": "Certificate default Duration",
                  "type": "string"
                },
                "ipAddresses": {
                  "description": "IPAddresses is a list of IP addresses to be used on the Certificate",
                  "items": {
                    "type": "string"
                  },
                  "type": "array"
                },
                "isCA": {
                  "description": "IsCA will mark this Certificate as valid for signing. This implies that the 'signing' usage is set",
                  "type": "boolean"
                },
                "issuerRef": {
                  "description": "IssuerRef is a reference to the issuer for this certificate. If the 'kind' field is not set, or set to 'Issuer', an Issuer resource with the given name in the same namespace as the Certificate will be used. If the 'kind' field is set to 'ClusterIssuer', a ClusterIssuer with the provided name will be used. The 'name' field in this stanza is required at all times.",
                  "properties": {
                    "group": {
                      "type": "string"
                    },
                    "kind": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    }
                  },
                  "required": [
                    "name"
                  ],
                  "type": "object"
                },
                "keyAlgorithm": {
                  "description": "KeyAlgorithm is the private key algorithm of the corresponding private key for this certificate. If provided, allowed values are either \"rsa\" or \"ecdsa\" If KeyAlgorithm is specified and KeySize is not provided, key size of 256 will be used for \"ecdsa\" key algorithm and key size of 2048 will be used for \"rsa\" key algorithm.",
                  "enum": [
                    "rsa",
                    "ecdsa"
                  ],
                  "type": "string"
                },
                "keyEncoding": {
                  "description": "KeyEncoding is the private key cryptography standards (PKCS) for this certificate's private key to be encoded in. If provided, allowed values are \"pkcs1\" and \"pkcs8\" standing for PKCS#1 and PKCS#8, respectively. If KeyEncoding is not specified, then PKCS#1 will be used by default.",
                  "type": "string"
                },
                "keySize": {
                  "description": "KeySize is the key bit size of the corresponding private key for this certificate. If provided, value must be between 2048 and 8192 inclusive when KeyAlgorithm is empty or is set to \"rsa\", and value must be one of (256, 384, 521) when KeyAlgorithm is set to \"ecdsa\".",
                  "format": "int64",
                  "type": "integer"
                },
                "organization": {
                  "description": "Organization is the organization to be used on the Certificate",
                  "items": {
                    "type": "string"
                  },
                  "type": "array"
                },
                "renewBefore": {
                  "description": "Certificate renew before expiration duration",
                  "type": "string"
                },
                "secretName": {
                  "description": "SecretName is the name of the secret resource to store this secret in",
                  "type": "string"
                }
              },
              "required": [
                "secretName",
                "issuerRef"
              ],
              "type": "object"
            },
            "status": {
              "properties": {
                "conditions": {
                  "items": {
                    "properties": {
                      "lastTransitionTime": {
                        "description": "LastTransitionTime is the timestamp corresponding to the last status change of this condition.",
                        "format": "date-time",
                        "type": "string"
                      },
                      "message": {
                        "description": "Message is a human readable description of the details of the last transition, complementing reason.",
                        "type": "string"
                      },
                      "reason": {
                        "description": "Reason is a brief machine readable explanation for the condition's last transition.",
                        "type": "string"
                      },
                      "status": {
                        "description": "Status of the condition, one of ('True', 'False', 'Unknown').",
                        "enum": [
                          "True",
                          "False",
                          "Unknown"
                        ],
                        "type": "string"
                      },
                      "type": {
                        "description": "Type of the condition, currently ('Ready').",
                        "type": "string"
                      }
                    },
                    "required": [
                      "type",
                      "status"
                    ],
                    "type": "object"
                  },
                  "type": "array"
                },
                "lastFailureTime": {
                  "format": "date-time",
                  "type": "string"
                },
                "notAfter": {
                  "description": "The expiration time of the certificate stored in the secret named by this resource in spec.secretName.",
                  "format": "date-time",
                  "type": "string"
                }
              },
              "type": "object"
            }
          }
        }
        JSON
    }
    version = "v1alpha1"
  }
}