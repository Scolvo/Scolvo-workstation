CREATE INDEX user_teamId_idx ON user(teamId);
CREATE INDEX user_email_idx ON user(email);

CREATE INDEX workplace_teamId_idx ON workplace(teamId);
CREATE INDEX workplace_name_idx ON workplace(name);

CREATE INDEX team_name_idx ON team(name);
CREATE INDEX team_location_idx ON team(location);

CREATE INDEX meetingRoom_name_idx ON meetingRoom(name);
CREATE INDEX meetingRoom_location_idx ON meetingRoom(location);

CREATE INDEX reservation_userId_idx ON reservation(userId);
CREATE INDEX reservation_workplaceId_idx ON reservation(workplaceId);
CREATE INDEX reservation_meetingRoomId_idx ON reservation(meetingRoomId);
CREATE INDEX reservation_start_idx ON reservation(start);
CREATE INDEX reservation_end_idx ON reservation(end);
