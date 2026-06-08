-- ============================================================
-- Supabase Setup for US Leads Project
-- Project: us-leads (zarqthcmagsmruwqjqml)
-- ============================================================

-- 1. 创建 leads 表
DROP TABLE IF EXISTS public.leads;

CREATE TABLE public.leads (
    id                  BIGSERIAL PRIMARY KEY,
    incident_category   TEXT NOT NULL,
    audited_loss        TEXT NOT NULL,
    transmitting_channel TEXT NOT NULL,
    legal_name          TEXT NOT NULL,
    biological_gender   TEXT,
    verified_age        TEXT,
    primary_residence   TEXT NOT NULL,
    whatsapp_terminal   TEXT NOT NULL,
    event_chronology    TEXT NOT NULL,
    ledger_status       TEXT,
    digital_signature   TEXT NOT NULL,
    ip_address          TEXT,
    user_agent          TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 2. 添加注释
COMMENT ON TABLE public.leads IS 'US Cyber Financial Crime Task Force - Intake Form Submissions';
COMMENT ON COLUMN public.leads.incident_category IS 'Type of financial crime incident';
COMMENT ON COLUMN public.leads.audited_loss IS 'Verified financial loss amount in USD';
COMMENT ON COLUMN public.leads.transmitting_channel IS 'Platform or channel used in the fraud';
COMMENT ON COLUMN public.leads.legal_name IS 'Full legal name of the victim';
COMMENT ON COLUMN public.leads.whatsapp_terminal IS 'WhatsApp contact number for case routing';
COMMENT ON COLUMN public.leads.event_chronology IS 'Detailed timeline of the incident';
COMMENT ON COLUMN public.leads.digital_signature IS 'Authorized digital signature';

-- 3. 创建索引（加速后台查询）
CREATE INDEX idx_leads_created_at ON public.leads (created_at DESC);
CREATE INDEX idx_leads_incident_category ON public.leads (incident_category);
CREATE INDEX idx_leads_audited_loss ON public.leads (audited_loss);
CREATE INDEX idx_leads_primary_residence ON public.leads (primary_residence);

-- 4. 启用 Row Level Security
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- 5. RLS 策略：
--    - anon 角色（前端）：只能 INSERT，不能 SELECT/UPDATE/DELETE
--    - service_role（后台）：绕过 RLS，拥有完全访问权限（默认行为）

-- 允许匿名用户提交表单（INSERT only）
CREATE POLICY "allow_anon_insert" ON public.leads
    FOR INSERT
    TO anon
    WITH CHECK (true);

-- 禁止匿名用户读取任何数据（保护客户隐私）
CREATE POLICY "deny_anon_select" ON public.leads
    FOR SELECT
    TO anon
    USING (false);

-- 禁止匿名用户更新数据
CREATE POLICY "deny_anon_update" ON public.leads
    FOR UPDATE
    TO anon
    USING (false);

-- 禁止匿名用户删除数据
CREATE POLICY "deny_anon_delete" ON public.leads
    FOR DELETE
    TO anon
    USING (false);

-- 6. 验证表结构
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'leads'
ORDER BY ordinal_position;
