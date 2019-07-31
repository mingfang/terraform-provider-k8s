resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "certificaterequests_certmanager_k8s_io" {
  metadata {
    labels = {
      "controller-tools.k8s.io" = "1.0"
    }
    name = "certificaterequests.certmanager.k8s.io"
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
      kind   = "CertificateRequest"
      plural = "certificaterequests"
      short_names = [
        "cr",
        "crs",
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
                "csr": {
                  "description": "Byte slice containing the PEM encoded CertificateSigningRequest",
                  "format": "byte",
                  "type": "string"
                },
                "duration": {
                  "description": "Requested certificate default Duration",
                  "type": "string"
                },
                "isCA": {
                  "description": "IsCA will mark the resulting certificate as valid for signing. This implies that the 'signing' usage is set",
                  "type": "boolean"
                },
                "issuerRef": {
                  "description": "IssuerRef is a reference to the issuer for this CertificateRequest.  If the 'kind' field is not set, or set to 'Issuer', an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the 'kind' field is set to 'ClusterIssuer', a ClusterIssuer with the provided name will be used. The 'name' field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to 'certmanager.k8s.io' if empty.",
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
                }
              },
              "required": [
                "issuerRef"
              ],
              "type": "object"
            },
            "status": {
              "properties": {
                "ca": {
                  "description": "Byte slice containing the PEM encoded certificate authority of the signed certificate.",
                  "format": "byte",
                  "type": "string"
                },
                "certificate": {
                  "description": "Byte slice containing a PEM encoded signed certificate resulting from the given certificate signing request.",
                  "format": "byte",
                  "type": "string"
                },
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