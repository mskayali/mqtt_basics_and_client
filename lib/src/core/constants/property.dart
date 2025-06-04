
/// MQTT v5 property names used in packets.
/// These string constants correspond to MQTT packet properties.
class Property {
  static const String payloadFormatIndicator = 'payload_format_indicator';
  static const String messageExpiryInterval = 'message_expiry_interval';
  static const String contentType = 'content_type';
  static const String responseTopic = 'response_topic';
  static const String correlationData = 'correlation_data';
  static const String subscriptionIdentifier = 'subscription_identifier';
  static const String sessionExpiryInterval = 'session_expiry_interval';
  static const String assignedClientIdentifier = 'assigned_client_identifier';
  static const String serverKeepAlive = 'server_keep_alive';
  static const String authenticationMethod = 'authentication_method';
  static const String authenticationData = 'authentication_data';
  static const String requestProblemInformation = 'request_problem_information';
  static const String willDelayInterval = 'will_delay_interval';
  static const String requestResponseInformation = 'request_response_information';
  static const String responseInformation = 'response_information';
  static const String serverReference = 'server_reference';
  static const String reasonString = 'reason_string';
  static const String receiveMaximum = 'receive_maximum';
  static const String topicAliasMaximum = 'topic_alias_maximum';
  static const String topicAlias = 'topic_alias';
  static const String maximumQos = 'maximum_qos';
  static const String retainAvailable = 'retain_available';
  static const String userProperty = 'user_property';
  static const String maximumPacketSize = 'maximum_packet_size';
  static const String wildcardSubscriptionAvailable = 'wildcard_subscription_available';
  static const String subscriptionIdentifierAvailable = 'subscription_identifier_available';
  static const String sharedSubscriptionAvailable = 'shared_subscription_available';
}
