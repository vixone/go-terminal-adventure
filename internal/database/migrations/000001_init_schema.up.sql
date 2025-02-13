CREATE TABLE sessions (
    id UUID PRIMARY KEY,
    created_at TIMESTAMP DEFAULT now(),
    last_active TIMESTAMP DEFAULT now(),
    current_act INTEGER DEFAULT 1  -- Or reference to the current act/scene
);

CREATE TABLE decisions (
    id SERIAL PRIMARY KEY,
    session_id UUID REFERENCES sessions(id),
    act INTEGER,  -- If the game has acts, otherwise this could be a scene or chapter identifier
    decision JSONB,  -- Store decision details, choice made, and any parameters
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE acts (
    act_number INTEGER PRIMARY KEY,
    title TEXT,
    narrative TEXT,
    choices JSONB  -- possible choices for that act, if you want to store that data centrally
);
