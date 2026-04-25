const String createUserTable = '''
          create table user(
            id integer primary key,
            firstName text not null,
            lastName text not null,
            email text not null,
            password text
          )
          ''';

const String createObjectTable = '''
          create table object(
            id integer primary key,
            publicName text not null,
            privateName text not null,
            password text,
            userId integer references user(id),
            maxTemperature float,
            defaultSpeedForDevices integer
          )
          ''';

const String createDeviceTable = '''
          create table device(
            id integer primary key,
            publicName text not null,
            privateName text not null,
            password text,
            objectId integer references object(id)
          )
          ''';

const String createTemperatureGraphPointTable = '''
          create table temperatureGraphPoint(
            id integer primary key,
            objectId integer references object(id),
            time datetime not null,
            value float not null
          )
          ''';

const String createSpeedGraphPointTable = '''
          create table speedGraphPoint(
            id integer primary key,
            deviceId integer references device(id),
            time datetime not null,
            value float not null
          )
          ''';
