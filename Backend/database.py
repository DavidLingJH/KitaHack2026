from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

# SQLALCHEMY_DATABASE_URL = "sqlite:///./blog.db"
SQLALCHEMY_DATABASE_URL = "postgresql://postgresql:dataZen963@localhost:8888/kitahackDB"

engine = create_async_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
)

# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False
)


class Base(DeclarativeBase):
    pass


# def get_db():
#     with SessionLocal() as db:
#         yield db


async def get_db():
    async with AsyncSessionLocal() as session:
        yield session