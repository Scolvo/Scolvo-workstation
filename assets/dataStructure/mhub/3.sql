CREATE TABLE note (id TEXT NOT NULL, meeting_room_id TEXT NOT NULL, title TEXT NOT NULL, notes TEXT NOT NULL, checked TEXT NOT NULL, createdAt BIGINT, createdBy TEXT, CONSTRAINT note_id_pk PRIMARY KEY (id));
CREATE INDEX note_meeting_room_id_idx ON note(meeting_room_id);
CREATE INDEX note_checked_idx ON note(checked);
CREATE INDEX note_createdAt_idx ON note(createdAt);
CREATE INDEX note_createdBy_idx ON note(createdBy);
