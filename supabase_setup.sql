-- Vemu Quiz Craft - Supabase Schema Setup

-- 1. Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Users Table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT DEFAULT 'student',
    "profilePic" TEXT,
    "collegeId" TEXT,
    branch TEXT,
    year TEXT,
    "collegeName" TEXT,
    "isVerified" BOOLEAN DEFAULT TRUE,
    "createdAt" TIMESTAMPTZ DEFAULT NOW()
);

-- 3. OTPs Table
CREATE TABLE IF NOT EXISTS otps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL,
    otp TEXT NOT NULL,
    type TEXT NOT NULL,
    "expiresAt" TIMESTAMPTZ NOT NULL,
    "createdAt" TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Quizzes Table
CREATE TABLE IF NOT EXISTS quizzes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    language TEXT,
    questions JSONB,
    duration INTEGER,
    "scheduledAt" TIMESTAMPTZ,
    "endTime" TIMESTAMPTZ,
    "isLive" BOOLEAN DEFAULT TRUE,
    "passingScore" INTEGER DEFAULT 40,
    "createdBy" UUID REFERENCES users(id),
    "createdAt" TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Quiz Attempts Table
CREATE TABLE IF NOT EXISTS quiz_attempts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "studentId" UUID REFERENCES users(id),
    "quizId" UUID REFERENCES quizzes(id),
    answers JSONB,
    score INTEGER,
    "totalMarks" INTEGER,
    percentage FLOAT,
    "timeTaken" INTEGER,
    status TEXT,
    "submittedAt" TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "userId" UUID REFERENCES users(id),
    type TEXT DEFAULT 'info',
    message TEXT NOT NULL,
    "isRead" BOOLEAN DEFAULT FALSE,
    "createdAt" TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Basic Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_student ON quiz_attempts("studentId");
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_quiz ON quiz_attempts("quizId");
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications("userId");

-- 8. Disable RLS (to match previous behavior where backend handles everything)
-- Note: In a production environment, you should enable RLS and set proper policies.
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE otps DISABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes DISABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts DISABLE ROW LEVEL SECURITY;
ALTER TABLE notifications DISABLE ROW LEVEL SECURITY;
