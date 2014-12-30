# HelloPacket
class HelloRequest < Packet
  required
  int :request
end
class HelloResponse < Packet
  required
  int :response
end

class Fruits < Enum
  required
  keys [
    :Apple,
    :Banana,
    :Grape ]
end