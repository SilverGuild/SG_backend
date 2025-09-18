class UserSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :username,
              :email
end
