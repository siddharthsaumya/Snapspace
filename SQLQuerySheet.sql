create database SnapspaceDB;
use SnapspaceDB;

CREATE TABLE SecurityQuestions (
	Id INT PRIMARY KEY IDENTITY(1,1),
	Question VARCHAR(MAX)
);

CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL, -- Password@123
    Email VARCHAR(100) UNIQUE NOT NULL,
    FullName VARCHAR(100),
    Bio VARCHAR(MAX),
    ProfilePicture VARCHAR(MAX),
    CreatedAt datetime DEFAULT(getdate()),
    OnlineStatus BIT DEFAULT 1, -- 0: Offline, 1: Online,
	Active BIT DEFAULT 1, -- 0: Not Active, 1: Active,
	SecurityQuestionId INT,
	SecurityAnswer VARCHAR(MAX),
	FOREIGN KEY (SecurityQuestionId) REFERENCES SecurityQuestions(Id)
);

CREATE TABLE Follow (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FollowerId INT,
    FollowingId INT,
    CreatedAt datetime DEFAULT(getdate()),
    FOREIGN KEY (FollowerId) REFERENCES Users(Id),
    FOREIGN KEY (FollowingId) REFERENCES Users(Id)
);

CREATE TABLE FollowRequest (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FromUserId INT,
    ToUserId INT,
    Status INT NOT NULL DEFAULT 0, -- 0: Pending, 1: Accepted 2: Declined
    CreatedAt datetime DEFAULT(getdate()),
    FOREIGN KEY (FromUserId) REFERENCES Users(Id),
    FOREIGN KEY (ToUserId) REFERENCES Users(Id)
);

CREATE TABLE Notification (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT,
    NotificationType INT NOT NULL, -- 0: FollowRequest, 1: Follower, 2: Following, 3: Like, 4: Comment
    SourceId INT, -- POST Id, User Id
    CreatedAt datetime DEFAULT(getdate()),
    ReadStatus BIT DEFAULT 0, -- 0: Unread, 1: Read
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE Posts (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT,
    ImageUrl VARCHAR(MAX),
    Caption VARCHAR(MAX),
    CreatedAt datetime DEFAULT(getdate()),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
	Active BIT DEFAULT 1 -- 0: Not Active, 1: Active
);

CREATE TABLE Comments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PostId INT,
    UserId INT,
    CommentText VARCHAR(MAX),
    ParentCommentId INT NULL,
    CreatedAt datetime DEFAULT(getdate()),
    FOREIGN KEY (PostId) REFERENCES Posts(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (ParentCommentId) REFERENCES Comments(Id)
);

CREATE TABLE Likes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PostId INT,
    UserId INT,
    CreatedAt datetime DEFAULT(getdate()),
    FOREIGN KEY (PostId) REFERENCES Posts(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE Chats (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CreatedAt datetime DEFAULT(getdate())
);

CREATE TABLE ChatParticipants (
    ChatId INT,
    UserId INT,
    PRIMARY KEY (ChatId, UserId),
    FOREIGN KEY (ChatId) REFERENCES Chats(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE Messages (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ChatId INT,
    SenderId INT,
    MessageText VARCHAR(MAX),
    CreatedAt datetime DEFAULT(getdate()),
    ReadStatus BIT DEFAULT 0, -- 0: Unread, 1: Read
    FOREIGN KEY (ChatId) REFERENCES Chats(Id),
    FOREIGN KEY (SenderId) REFERENCES Users(Id)
);

CREATE TABLE Logs (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LogType INT, -- 0:Auth, 1:Profile, 2:Post, 3:Conversation, 4:Interaction, 5:Error
    UserId INT,
    LogDetails VARCHAR(MAX),
    CreatedAt datetime DEFAULT(getdate()),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE Tags (
    Id INT PRIMARY KEY IDENTITY(1,1),
    TagName VARCHAR(100)
	
);

CREATE TABLE TagBinding (
	PostId INT,
	TagId INT,
	PRIMARY KEY (PostId, TagId),
    FOREIGN KEY (PostId) REFERENCES Posts(Id),
	FOREIGN KEY (TagId) REFERENCES Tags(Id)
);

SELECT * FROM Users;
SELECT * FROM SecurityQuestions;
SELECT * FROM Posts;
SELECT * FROM Follow;
SELECT * FROM FollowRequest;
SELECT * FROM Comments;
SELECT * FROM Likes;
SELECT * FROM Chats;
SELECT * FROM ChatParticipants;
SELECT * FROM Messages;
SELECT * FROM Posts;
SELECT * FROM Tags;
SELECT * FROM TagBinding;
SELECT * FROM Notification;
SELECT * FROM Logs;

delete from SecurityQuestions where Id > 4;

UPDATE Users set OnlineStatus=1 where Id = 3;

INSERT INTO SecurityQuestions (Question)
VALUES 
('What is your favorite color?'),
('What is the name of the city where you were born?'),
('What was the make of your first car?'),
('What is your favorite book?'),
('What was the name of your first teacher?'),
('What is your favorite movie?'),
('What was the name of your first boss?'),
('What is your favorite food?'),
('What is the name of your childhood best friend?'),
('What is the name of your first school?'),
('What is your favorite sports team?'),
('What is your favorite hobby?'),
('What was the name of your first crush?');
