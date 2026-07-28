package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sn.fenal.backend.model.SessionChat;

public interface SessionChatRepository extends JpaRepository<SessionChat, Integer> {
}
