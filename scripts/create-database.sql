USE [master]

DROP DATABASE IF EXISTS [tvz2]
GO

CREATE DATABASE [tvz2]
GO

USE [tvz2]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [varchar](255) NULL,
  [ContentType] [varchar](255) NULL,
  [Data] [varbinary](MAX) NULL,
  [Size] [bigint] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [varchar](255) NULL,
  [ISVU] [varchar](50) NULL,
  [ECTS] [int] NULL,
  [LandingPage] [varchar](max) NULL,
  [Password] [varchar](255) NULL,
  [MadeByID] [int] NULL,
  [SpecializationID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Username] [varchar](255) NULL,
  [PasswordHash] [varbinary](255) NULL,
  [PasswordSalt] [varbinary](255) NULL,
  [Created] [datetime2](7) NULL DEFAULT CURRENT_TIMESTAMP,
  [Name] [varchar](255) NULL,
  [Surname] [varchar](255) NULL,
  [Email] [varchar](255) NULL,
  [ImageFileID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [JoinedAt] [datetime2](7) NULL DEFAULT CURRENT_TIMESTAMP,
  [Blacklisted] [bit] NULL DEFAULT 0,
  [UserID] [int] NULL,
  [CourseID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SidebarContent]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Title] [varchar](255) NULL,
  [CourseID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SidebarContentFile]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [SidebarContentID] [int] NULL,
  [FileID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Specialization]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [varchar](255) NULL,
  [Shorthand] [varchar](20) NULL
    PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Title] [varchar](255) NULL,
  [SubmittedAt] [datetime2](7) NULL,
  [ExpiresAt] [datetime2](7) NULL,
  [Description] [varchar](max) NULL,
  [Color] [varchar](255) NULL,
  [CourseID] [int] NULL,
  [SubmittedByID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationUserSeen]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [NotificationID] [int] NULL,
  [UserID] [int] NULL,
  [Seen] [bit] DEFAULT 0,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [varchar](255) NULL,
  [DueDate] [datetime2](7) NULL,
  [TimeNeeded] [int] NOT NULL,
  [Finalized] [bit] DEFAULT 0,
  [Enabled] [bit] DEFAULT 0,
  [CourseID] [int] NULL,
  [CreatedByID] [int] NULL
    PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamAttempt]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Terminated] [bit] NULL,
  [Started] [bit] NULL,
  [StartedAt] [datetime2](7) NULL,
  [UserID] [int] NULL,
  [ExamID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAnswer]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [AttemptID] [int] NULL,
  [QuestionID] [int] NULL,
  [AnswerID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Title] [varchar](255) NULL,
  [Content] [varchar](max) NULL,
  [Value] [int] NOT NULL DEFAULT 1,
  [ExamID] [int] NULL,
  [TypeID] [int] NULL
    PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionType]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [varchar](255) NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answer]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Content] [varchar](max) NULL,
  [Correct] [bit] NULL,
  [QuestionID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chat]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [FirstParticipantID] [int] NOT NULL,
  [SecondParticipantID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Content] [varchar](max) NOT NULL,
  [SentAt] [datetime2](7) CONSTRAINT dfDate DEFAULT GETDATE(),
  [UserID] [int] NOT NULL,
  [ChatID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Privilege]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [varchar](max) NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPrivilege]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [UserID] [int] NOT NULL,
  [PrivilegeID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCoursePrivilege]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [UserID] [int] NOT NULL,
  [PrivilegeID] [int] NOT NULL,
  [CourseID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSettings]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [UserID] [int] NOT NULL,
  [DarkMode] [bit] NULL DEFAULT 0,
  [Locale] [varchar](2) NOT NULL DEFAULT 'en',
  [Popups] [bit] NULL DEFAULT 1,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationFile]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [NotificationID] [int] NOT NULL,
  [FileID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseTask]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [GradeMaximum] [int] NOT NULL,
  [CreatedByID] [int] NOT NULL,
  [DueDate] [datetime2](7) NOT NULL,
  [Description] [varchar](max) NOT NULL,
  [Title] [varchar](max) NOT NULL,
  [CourseID] [int] NOT NULL,
  [SubmittedAt] [datetime2](7) DEFAULT GETDATE(),
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseTaskAttachment]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [FileID] [int] NOT NULL,
  [CourseTaskID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseTaskAttempt]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [Description] [varchar](max) NOT NULL,
  [Grade] [int] NOT NULL,
  [UserID] [int] NOT NULL,
  [SubmittedAt] [datetime2](7) NOT NULL,
  [CourseTaskID] [int] NOT NULL,
  [GradeeComment] [varchar](max),
  [GradedById] [int],
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskAttemptAttachment]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [FileID] [int] NOT NULL,
  [CourseTaskAttemptID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discussion]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [SubmittedAt] [datetime2](7) NULL,
  [Content] [varchar](max) NULL,
  [CourseID] [int] NULL,
  [SubmittedByID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscussionComment]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [SubmittedAt] [datetime2](7) NULL,
  [Content] [varchar](max) NULL,
  [DiscussionID] [int] NULL,
  [SubmittedByID] [int] NULL,
  PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

DROP TRIGGER IF EXISTS NewUserSettingsTrigger
GO

DROP TRIGGER IF EXISTS NewCourseTrigger
GO

CREATE TRIGGER NewUserSettingsTrigger on [dbo].[User]
FOR INSERT 
AS 
INSERT INTO [UserSettings]
  ([UserID])
SELECT ID
FROM INSERTED;
GO

CREATE TRIGGER NewCourseTrigger on [dbo].[Course]
FOR INSERT 
AS 
INSERT INTO [SidebarContent]
  ([CourseID], [Title])
VALUES
  ((SELECT ID
    FROM INSERTED), 'Notification files');
UPDATE [Course]
SET [LandingPage] = '<div align="center"><h2><font size="6">Welcome to the course!</font></h2><div align="left"><u>Rules:</u></div><div align="left">1. Do not cheat</div><div align="left">2. Ask others for help</div><div align="left">3. Consult the higher-ups for additional assistance</div><div align="left">4. Behave rationally</div><div align="left">5. No image macros</div><div align="left">6. No NSFW content</div><div align="left">7. All consultations go to <b>email@email.com</b><br></div></div>'
WHERE [ID] = (SELECT ID
FROM INSERTED)
GO

-- Foreign key constraints

-- Exam

ALTER TABLE [dbo].[Exam] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Exam] WITH CHECK ADD FOREIGN KEY([CreatedByID])
REFERENCES [dbo].[User] ([ID]) 
GO

-- ExamAttempt

ALTER TABLE [dbo].[ExamAttempt] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ExamAttempt] WITH CHECK ADD FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exam] ([ID]) 
GO

-- UserAnswer

ALTER TABLE [dbo].[UserAnswer] WITH CHECK ADD FOREIGN KEY([AttemptID])
REFERENCES [dbo].[ExamAttempt] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserAnswer] WITH CHECK ADD FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserAnswer] WITH CHECK ADD FOREIGN KEY([AnswerID])
REFERENCES [dbo].[Answer] ([ID]) 
GO

-- Question

ALTER TABLE [dbo].[Question] WITH CHECK ADD FOREIGN KEY([ExamID])
REFERENCES [dbo].[Exam] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Question] WITH CHECK ADD FOREIGN KEY([TypeID])
REFERENCES [dbo].[QuestionType] ([ID]) ON DELETE CASCADE
GO

-- Answer

ALTER TABLE [dbo].[Answer] WITH CHECK ADD FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([ID]) ON DELETE CASCADE
GO

-- Course

ALTER TABLE [dbo].[Course] WITH CHECK ADD FOREIGN KEY([SpecializationID])
REFERENCES [dbo].[Specialization] ([ID]) ON DELETE CASCADE
GO

-- Subscription

ALTER TABLE [dbo].[Subscription] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Subscription] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

-- SidebarContent

ALTER TABLE [dbo].[SidebarContent] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

-- Notification

ALTER TABLE [dbo].[Notification] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Notification] WITH CHECK ADD FOREIGN KEY([SubmittedByID])
REFERENCES [dbo].[User] ([ID]) 
GO

-- SidebarContentFile

ALTER TABLE [dbo].[SidebarContentFile] WITH CHECK ADD FOREIGN KEY([SidebarContentID])
REFERENCES [dbo].[SidebarContent] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SidebarContentFile] WITH CHECK ADD FOREIGN KEY([FileID])
REFERENCES [dbo].[File] ([ID]) ON DELETE CASCADE
GO

-- Chat

ALTER TABLE [dbo].[Chat] WITH CHECK ADD FOREIGN KEY([FirstParticipantID])
REFERENCES [dbo].[User] ([ID]) 
GO

ALTER TABLE [dbo].[Chat] WITH CHECK ADD FOREIGN KEY([SecondParticipantID])
REFERENCES [dbo].[User] ([ID]) 
GO

-- User

ALTER TABLE [dbo].[User] WITH CHECK ADD FOREIGN KEY([ImageFileID])
REFERENCES [dbo].[File] ([ID])  
GO

-- Message

ALTER TABLE [dbo].[Message] WITH CHECK ADD FOREIGN KEY([ChatID])
REFERENCES [dbo].[Chat] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Message] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

-- UserPrivilege

ALTER TABLE [dbo].[UserPrivilege] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserPrivilege] WITH CHECK ADD FOREIGN KEY([PrivilegeID])
REFERENCES [dbo].[Privilege] ([ID]) ON DELETE CASCADE
GO

-- UserSettings

ALTER TABLE [dbo].[UserSettings] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

-- NotificationUserSeen

ALTER TABLE [dbo].[NotificationUserSeen] WITH CHECK ADD FOREIGN KEY([NotificationID])
REFERENCES [dbo].[Notification] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[NotificationUserSeen] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

-- NotificationFile

ALTER TABLE [dbo].[NotificationFile] WITH CHECK ADD FOREIGN KEY([NotificationID])
REFERENCES [dbo].[Notification] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[NotificationFile] WITH CHECK ADD FOREIGN KEY([FileID])
REFERENCES [dbo].[File] ([ID]) ON DELETE CASCADE
GO

-- CourseTask

ALTER TABLE [dbo].[CourseTask] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CourseTask] WITH CHECK ADD FOREIGN KEY([CreatedByID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

-- CourseTaskAttachment

ALTER TABLE [dbo].[CourseTaskAttachment] WITH CHECK ADD FOREIGN KEY([FileID])
REFERENCES [dbo].[File] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CourseTaskAttachment] WITH CHECK ADD FOREIGN KEY([CourseTaskID])
REFERENCES [dbo].[CourseTask] ([ID]) ON DELETE CASCADE
GO

-- CourseTaskAttempt

ALTER TABLE [dbo].[CourseTaskAttempt] WITH CHECK ADD FOREIGN KEY([CourseTaskID])
REFERENCES [dbo].[CourseTask] ([ID])
GO

ALTER TABLE [dbo].[CourseTaskAttempt] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CourseTaskAttempt] WITH CHECK ADD FOREIGN KEY([GradedByID])
REFERENCES [dbo].[User] ([ID])
GO

-- TaskAttemptAttachment

ALTER TABLE [dbo].[TaskAttemptAttachment] WITH CHECK ADD FOREIGN KEY([CourseTaskAttemptID])
REFERENCES [dbo].[CourseTaskAttempt] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[TaskAttemptAttachment] WITH CHECK ADD FOREIGN KEY([FileID])
REFERENCES [dbo].[File] ([ID]) ON DELETE CASCADE
GO

-- UserCoursePrivilege

ALTER TABLE [dbo].[UserCoursePrivilege] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserCoursePrivilege] WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserCoursePrivilege] WITH CHECK ADD FOREIGN KEY([PrivilegeID])
REFERENCES [dbo].[Privilege] ([ID]) 
GO

-- Discussion

ALTER TABLE [dbo].[Discussion] WITH CHECK ADD FOREIGN KEY([SubmittedByID])
REFERENCES [dbo].[User] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Discussion] WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[DiscussionComment] WITH CHECK ADD FOREIGN KEY([DiscussionID])
REFERENCES [dbo].[Discussion] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[DiscussionComment] WITH CHECK ADD FOREIGN KEY([SubmittedByID])
REFERENCES [dbo].[User] ([ID])
GO

UPDATE [dbo].[Course] SET [Password] = 'testing'
GO
