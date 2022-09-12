docker-compose exec -T sql-client ./sql-client.sh <<-EOF
    CREATE TABLE subjects(
    subject_id INT,
    subject_name VARCHAR,
    course_id INT
    ) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.subjects',
    'properties.bootstrap.servers' = 'broker0:19092',
    'properties.group.id' = 'test-consumer-group',
    'value.format' = 'json',
    'scan.startup.mode' = 'earliest-offset'
    );

    CREATE TABLE courses(
    course_id INT,
    course_name VARCHAR
    ) WITH (
    'connector' = 'kafka',
    'topic' = 'demo.class.courses',
    'properties.bootstrap.servers' = 'broker1:19093',
    'properties.group.id' = 'test-consumer-group',
    'value.format' = 'json',
    'scan.startup.mode' = 'earliest-offset'
    );

    CREATE TABLE chapters(
    chapter_id INT,
    chapter_name VARCHAR,
    subject_id INT
    ) WITH (
    'connector' = 'kafka',
    'topic' = 'local.class.chapters',
    'properties.bootstrap.servers' = 'broker2:19094',
    'properties.group.id' = 'test-consumer-group',
    'value.format' = 'json',
    'scan.startup.mode' = 'earliest-offset'
    );

    CREATE TABLE subchapters(
    subchapter_id INT,
    subchapter_name VARCHAR,
    chapter_id INT
    ) WITH (
    'connector' = 'kafka',
    'topic' = 'file.subchap',
    'properties.bootstrap.servers' = 'broker0:19092',
    'properties.group.id' = 'test-consumer-group',
    'value.format' = 'json',
    'scan.startup.mode' = 'earliest-offset'
    );

    CREATE TABLE class_booost(
    course_name VARCHAR,
    subject_name VARCHAR,
    chapter_name VARCHAR,
    subchapter_name VARCHAR
    ) WITH (
    'connector' = 'kafka',
    'topic' = 'CLASS_BOOOST',
    'properties.bootstrap.servers' = 'broker0:19092',
    'properties.group.id' = 'test-consumer-group',
    'value.format' = 'json'
    );


    INSERT INTO class_booost
        SELECT courses.course_name as course_name, subjects.subject_name as subject_name, chapters.chapter_name as chapter_name, subchapters.subchapter_name as subchapter_name FROM courses INNER JOIN subjects ON courses.course_id = subjects.course_id INNER JOIN chapters ON subjects.subject_id = chapters.subject_id INNER JOIN subchapters ON chapters.chapter_id = subchapters.chapter_id;
EOF