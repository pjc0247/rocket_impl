Rocket
======

간단한 예제
----
* 패킷의 스키마를 작성
```Ruby
# 패킷 정의
class LoginRequest < Packet
  required # required 명시된 패킷만 빌드에 참여함
  string :user_id
  string :user_password
end

# 열거형 정의
class Fruits < Enum
  required
  keys [
    :Apple,
    :Banana,
    :Grape ]
end
```

* PGen 스크립트 실행
```
pgen -s scheme.rb -d .\src\packets.h
```
