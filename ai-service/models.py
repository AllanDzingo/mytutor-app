from sqlalchemy import Column, Integer, String
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    grade = Column(String, nullable=True)
    subject = Column(String, nullable=True)
    tutor_name = Column(String, nullable=True)
