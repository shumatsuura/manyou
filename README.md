# Table Structure

#### 1. users table
  - id: integer
  - name: string
  - email: string
  - password_digest: string

#### 2. tasks
  - id: integer
  - user_id(FK) : integer
  - name: string
  - description: text
  - priority: string
  - due_time: timestamp
  - status: string

#### 3. labels
  - id: integer
  - task_id(FK): integer
  - user_id(FK): intger
  - name: string
